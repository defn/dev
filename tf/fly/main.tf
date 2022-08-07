terraform {
  cloud {
    organization = "defn"

    workspaces {
      name = "fly"
    }
  }
}

provider "fly" {}

resource "fly_app" "brie" {
  name = "brie"
}

resource "fly_volume" "brie" {
  name   = "brie"
  app    = fly_app.brie.name
  size   = 1
  region = "sjc"
}
