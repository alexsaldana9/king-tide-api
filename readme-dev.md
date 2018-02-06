# Collection of scripts to validate the api  

## create an api key  

```bash
rails runner "SecretKey.destroy_all"
rails runner "SecretKey.create(name: 'dev_key', key: 'dev_secret')"
```

## Read readings  

```bash
curl http://localhost:3001/readings/all/ | json_pp
curl http://localhost:3001/readings/pending/ | json_pp
curl http://localhost:3001/readings/approved/ | json_pp
```

## failed attempt to create a reading  

```bash
curl -X POST \
  -H 'apiKey:INVALID_KEY' \
  -F 'depth=3' \
  -F 'units_depth=feet' \
  http://localhost:3001/readings/ | json_pp
```

## create a reading  

```bash
curl -X POST \
  -H 'apiKey:dev_secret' \
  -F 'depth=3' \
  -F 'units_depth=feet' \
  http://localhost:3001/readings/ | json_pp
```

## approve a reading  

```bash
curl -X POST \
  -H 'apiKey:dev_secret' \
  -F 'id=7' \
  http://localhost:3001/readings/approve | json_pp
```

## delete a reading  

```bash
curl -X DELETE \
  -H 'apiKey:dev_secret' \
  -F 'id=8' \
  http://localhost:3001/readings | json_pp
```
