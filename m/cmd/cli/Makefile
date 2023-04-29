ignore:
	true

build:
	cd proto && buf mod update
	cd proto && buf build
	cd proto && buf lint
	cd proto && buf generate
	go install

server:
	cli server

client:
	buf curl --schema proto/pet/v1/pet.proto --data '{"pet_type": "PET_TYPE_SNAKE", "name": "Ekans"}' http://localhost:8080/pet.v1.PetStoreService/PutPet | jq .
	cli client
