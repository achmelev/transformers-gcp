###Basics
- Wir nutzen Terraform zur Anlage der Training VMs
- Konfigurationen für folgende Instanztypen:
    - n1-standard-1 - die kleinstmöglichste (und billigste) Instanz mit T4 GPU

####Befehle

terraform apply -var-file="<var_file>" - Eine VM mit einer durch <var_file> vorgegebenen Instanz anlegen
terraform destroy -var-file="<var_file>" - Eine VM mit einer durch <var_file> vorgegebenen Instanz anlegen

<var_file>'s:
  t4.small.tfvars  - Eine n1-standard-1 - Instanz mit anschließender Installation von Python, pythorch etc.


Am Ende der Anlageskripte wird die Public IP der angelegten Instanz ausgegeben.
Die Public IP nutzt man mit dem SSH um sich zur Instanz zu verbinden:

ssh -i Transformers.pem alexei_chmelev@<public_ip>
