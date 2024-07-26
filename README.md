# frr

**This FRR image is based out of Ubuntu 22.04 using below as the reference link: **
https://docs.frrouting.org/projects/dev-guide/en/latest/building-frr-for-ubuntu2204.html#⁠

**How to execute the image:** 
docker run --name H1 --cap-add=NET_ADMIN --cap-add SYS_ADMIN --rm -it jayaram07kg/frr:22.04 bash

**Docker Image:**
https://hub.docker.com/r/jayaram07kg/frr

**Execute the below command to start the FRR service:**
systemctl start frr
