import docker
import time
import sys
from docker.types import DeviceRequest
import signal
import os
import torch

class GracefulKiller:
  kill_now = False
  def __init__(self):
    signal.signal(signal.SIGINT, self.exit_gracefully)
    signal.signal(signal.SIGTERM, self.exit_gracefully)

  def exit_gracefully(self, *args):
    self.kill_now = True

client = docker.from_env()
containers = client.containers.list()
print("Inside docker container now, running docker gpu orchestrator")

if "TI_DOCKER_GPU_ORCHESTRATOR_HAS_GPU_ACCESS" in os.environ:
    print("Orchestrator has GPU Access!")

if "TI_DOCKER_GPU_ORCHESTRATOR_HAS_GPU_ACCESS" in os.environ:
    print("Running replica with GPU acccess, performing discovery")
    print("TOTAL GPUs ON THE SYSTEM {}".format(torch.cuda.device_count()))
    for index in range(torch.cuda.device_count()):
        t = torch.cuda.get_device_properties(index).total_memory
        r = torch.cuda.memory_reserved(index)
        a = torch.cuda.memory_allocated(index)
        f = r-a  # free inside reserved

        print("Total memory gpu {}: {} MB".format(index,t/1024/1024))
        print("Reserved memory gpu {}: {}".format(index,r))
        print("Allocated memory gpu {}: {}".format(index,a))
        print("Free memory gpu {}: {} MB".format(index,(t-r)/1024/1024))
    print("Spawning a GPU agent for every GPU on the system")
    containers = []
    for index in range(torch.cuda.device_count()):
        start_with_name = "textimager-gpu-agent-"+str(index+1)

        device_requests = device_requests=[DeviceRequest(driver="nvidia",capabilities=[["gpu","utility","compute"]])]

        env = {"TI_DOCKER_HEAD_HOST": 'textimager-server', "TI_DOCKER_GPU_ORCHESTRATOR_HAS_GPU_ACCESS": "true", "NVIDIA_VISIBLE_DEVICES":str(index)}
        sshfs = docker.types.Mount("/home/ducc/ducc",source="ducc_shared",no_copy=True)
        cont = client.containers.run(client.images.get(os.environ["TI_DOCKER_GPU_AGENT_IMAGE_NAME"]),None,remove=True,detach=True,environment=env,device_requests=device_requests,name=start_with_name,hostname=start_with_name,network="textimager_ducc_net", mounts=[sshfs])
        containers.append(cont)
    killer = GracefulKiller()
    while not killer.kill_now:
        time.sleep(1)
        print("Waiting for sigterm...")

    print("Received sigterm shutting down container...")
    for cont in containers:
        cont.stop(timeout=2)
    sys.exit(0)

else:
    start_with_name = "textimager-gpu-orchestrator_withgpu"

    device_requests = device_requests=[DeviceRequest(driver="nvidia",capabilities=[["gpu","utility","compute"]])]

    env = {"TI_DOCKER_HEAD_HOST": 'textimager-server', "TI_DOCKER_GPU_ORCHESTRATOR_HAS_GPU_ACCESS": "true", "TI_DOCKER_GPU_AGENT_IMAGE_NAME": os.environ["TI_DOCKER_GPU_AGENT_IMAGE_NAME"]}
    cont = client.containers.run(client.images.get(os.environ["TI_DOCKER_GPU_ORCHESTRATOR_IMAGE_NAME"]),None,remove=True,detach=True,environment=env,device_requests=device_requests,name=start_with_name,volumes=["/var/run/docker.sock:/var/run/docker.sock"])

    killer = GracefulKiller()
    while not killer.kill_now:
        time.sleep(1)
        print("Waiting for sigterm...")

    print("Received sigterm shutting down container...")
    cont.stop()
    sys.exit(0)
