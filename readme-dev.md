# Collection of scripts to validate the api  

## Api Status  

```bash
curl -s http://localhost:3001/status/ | json_pp
```

## create an api key  

```bash
rails runner "SecretKey.destroy_all"
rails runner "SecretKey.create(name: 'dev_key', key: 'dev_secret')"
```

## Read readings  

```bash
curl -s http://localhost:3001/readings/all/ | json_pp
curl -s http://localhost:3001/readings/7 | json_pp
curl -s http://localhost:3001/readings/pending/ | json_pp
curl -s http://localhost:3001/readings/approved/ | json_pp
```

## failed attempt to create a reading  

```bash
curl -s -X POST \
  -H 'apiKey:INVALID_KEY' \
  -F 'depth=3' \
  -F 'units_depth=feet' \
  http://localhost:3001/readings/ | json_pp
```

## create a reading  

```bash
curl -s -X POST \
  -H 'apiKey:dev_secret' \
  -F 'depth=3' \
  -F 'units_depth=feet' \
  http://localhost:3001/readings/ | json_pp
```

## approve a reading  

```bash
curl -s -X POST \
  -H 'apiKey:dev_secret' \
  -F 'id=7' \
  http://localhost:3001/readings/approve | json_pp
```

## delete a reading  

```bash
curl -s -X DELETE \
  -H 'apiKey:dev_secret' \
  -F 'id=8' \
  http://localhost:3001/readings | json_pp
```

## attach a photo to a reading  

```bash
curl -s -X POST \
  -H 'apiKey:dev_secret' \
  -F 'reading_id=7' \
  -F 'category=1' \
  -F 'image=@./test/fixtures/files/test_image_1.jpg' \
  http://localhost:3001/photos | json_pp
```

If the photo upload fails there may be a problem with `imagemagick`.  
[Check this out](https://github.com/thoughtbot/paperclip/issues/1405) or alternatively run this and try again   

```bash
brew remove imagemagick && brew install imagemagick
```
