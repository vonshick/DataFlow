# DataFlow
Keras neural network deployed on Azure with Ansible and Docker.

Neural network model is trained for accommodation price prediction in specific neighbourhood. 

Docker allows run R scripts in preconfigured environment. 

Ansible deploys Docker image on remote virtual machine (set up on Azure).

Trained model is saved on a machine after running the docker image.

To deploy script with Ansible 
1. Pass the IP address in **host** file.
2. Change username in **main.yml**.
3. Run following command:

```
ansible-playbook -i hosts main.yml --ask-become-pass
```
