# skyux-vmssagentspool-custom-scripts

### Setup
```
az login
```
```
az vmss extension set \
  --publisher Microsoft.Azure.Extensions \
  --version 2.0 \
  --name CustomScript \
  --resource-group vmssagents \
  --vmss-name skyux-vmssagentspool \
  --settings @config.json
```
