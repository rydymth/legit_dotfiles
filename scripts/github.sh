#!/bin/bash

token="Naah get your own bruh"
count=`curl -u username:$token https://api.github.com/notifications | jq '. | length'`

echo '{"text":'$count',"tooltip":"$tooltip","class":"$class"}'
