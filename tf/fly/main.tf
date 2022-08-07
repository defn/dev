terraform {
  cloud {
    organization = "defn"

    workspaces {
      name = "fly"
    }
  }
}

provider "fly" {}

resource "fly_app" "dev" {
  for_each = toset(local.flies)

  org  = "personal"
  name = each.key
}

resource "fly_volume" "dev" {
  for_each = toset(local.flies)

  name   = "data"
  size   = 1
  region = "sjc"

  app = fly_app.dev[each.key].name
}
