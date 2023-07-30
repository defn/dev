module "defn-org" {
    source = "../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.defn-org
    }
}

module "imma-amanibhavam" {
    source = "../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.imma-amanibhavam
    }
}

module "imma-dev" {
    source = "../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.imma-dev
    }
}

module "imma-dgwyn" {
    source = "../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.imma-dgwyn
    }
}

module "imma-org" {
    source = "../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.imma-org
    }
}

module "imma-prod" {
    source = "../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.imma-prod
    }
}

module "imma-tolan" {
    source = "../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.imma-tolan
    }
}

module "immanent-changer" {
    source = "../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.immanent-changer
    }
}

module "immanent-chanter" {
    source = "../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.immanent-chanter
    }
}

module "immanent-doorkeeper" {
    source = "../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.immanent-doorkeeper
    }
}

module "immanent-ged" {
    source = "../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.immanent-ged
    }
}

module "immanent-hand" {
    source = "../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.immanent-hand
    }
}

module "immanent-herbal" {
    source = "../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.immanent-herbal
    }
}

module "immanent-namer" {
    source = "../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.immanent-namer
    }
}

module "immanent-org" {
    source = "../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.immanent-org
    }
}

module "immanent-patterner" {
    source = "../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.immanent-patterner
    }
}

module "immanent-roke" {
    source = "../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.immanent-roke
    }
}

module "immanent-summoner" {
    source = "../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.immanent-summoner
    }
}

module "immanent-windkey" {
    source = "../terraform-aws-defn-account"
    context = module.this.context

    providers = {
        aws = aws.immanent-windkey
    }
}

