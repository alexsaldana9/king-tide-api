# Collection of scripts to validate the api  

## create a reading  

```bash
curl -X POST \
  -H 'apiKey:SECRET KEY' \
  -F 'depth=3' \
  -F 'units_depth=feet' \
  -F 'description=empty' \
  http://localhost:3001/readings/
```
