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
  name   = "data"
  size   = 1
  region = "sjc"

  app    = fly_app.brie.name
}
