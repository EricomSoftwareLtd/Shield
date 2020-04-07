import subprocess
import os
import sys
import yaml
import copy

if len(sys.argv) <=1:
    print("did not specify values.yml location")
    print("fetching values")
    subprocess.run(["helm","fetch", "shield-repo/shield"])
    subprocess.run('tar -xvf *.tgz shield/values.yaml',shell=True)
    values=os.getcwd()+"/shield/values.yaml"
else:
    values=sys.argv[1]



runningimages=[str(subprocess.check_output(['kubectl', 'get', 'pods', '--all-namespaces', '-o', 'jsonpath="{.items[*].spec.containers[*].image}"'])).split(' ')]
with open(values) as file:
    valuefile = yaml.load(file, yaml.FullLoader)

list={}
for key, value in valuefile["shield-mng"]["images"].items():
    list[key]=value

excludedImages=[]
if "unused-images" in valuefile:
    for image in valuefile["unused-images"]:
        excludedImages.append(image)
else:
    print("could not find unused images value in values.yaml.. using default..")
    excludedImages=['esNodeGroupsScaler','esBrowserScheduler','esLdapApi','esShieldCLI','esExternalDNS']


notfound=copy.deepcopy(list)
for name in list:
    if name not in excludedImages:
        if any(list[name] in s for s in runningimages):
            notfound.pop(name)
    else:
        print(name+"is in excluded images, ignoring....")
        notfound.pop(name)

if len(notfound) > 0:
    print("these images could not be found running..")
    print(notfound)
    exit(1)
else:
    print("*****all images as should*****")
# kubectl get pods --all-namespaces -o jsonpath="{.items[*].spec.containers[*].image}"