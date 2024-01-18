provider "aws" {
  alias = "defn-org"
  assume_role {
    role_arn = "arn:aws:iam::510430971399:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "coil-org"
  assume_role {
    role_arn = "arn:aws:iam::138291560003:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "coil-lib"
  assume_role {
    role_arn = "arn:aws:iam::160764896647:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "coil-net"
  assume_role {
    role_arn = "arn:aws:iam::278790191486:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "coil-hub"
  assume_role {
    role_arn = "arn:aws:iam::453991412409:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "curl-net"
  assume_role {
    role_arn = "arn:aws:iam::101142583332:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "curl-lib"
  assume_role {
    role_arn = "arn:aws:iam::298406631539:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "curl-org"
  assume_role {
    role_arn = "arn:aws:iam::424535767618:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "curl-hub"
  assume_role {
    role_arn = "arn:aws:iam::804430872255:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "gyre-org"
  assume_role {
    role_arn = "arn:aws:iam::065163301604:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "gyre-ops"
  assume_role {
    role_arn = "arn:aws:iam::319951235442:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "helix-sec"
  assume_role {
    role_arn = "arn:aws:iam::018520313738:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "helix-ops"
  assume_role {
    role_arn = "arn:aws:iam::368812692254:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "helix-lib"
  assume_role {
    role_arn = "arn:aws:iam::377857698578:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "helix-hub"
  assume_role {
    role_arn = "arn:aws:iam::436043820387:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "helix-net"
  assume_role {
    role_arn = "arn:aws:iam::504722108514:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "helix-pub"
  assume_role {
    role_arn = "arn:aws:iam::536806623881:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "helix-log"
  assume_role {
    role_arn = "arn:aws:iam::664427926343:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "helix-dmz"
  assume_role {
    role_arn = "arn:aws:iam::724643698007:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "helix-org"
  assume_role {
    role_arn = "arn:aws:iam::816178966829:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "helix-dev"
  assume_role {
    role_arn = "arn:aws:iam::843784871878:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "spiral-org"
  assume_role {
    role_arn = "arn:aws:iam::232091571197:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "spiral-net"
  assume_role {
    role_arn = "arn:aws:iam::057533398557:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "spiral-lib"
  assume_role {
    role_arn = "arn:aws:iam::073874947996:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "spiral-dmz"
  assume_role {
    role_arn = "arn:aws:iam::130046154300:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "spiral-hub"
  assume_role {
    role_arn = "arn:aws:iam::216704421225:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "spiral-dev"
  assume_role {
    role_arn = "arn:aws:iam::308726031860:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "spiral-pub"
  assume_role {
    role_arn = "arn:aws:iam::371657257885:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "spiral-sec"
  assume_role {
    role_arn = "arn:aws:iam::398258703387:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "spiral-log"
  assume_role {
    role_arn = "arn:aws:iam::442333715734:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "spiral-ops"
  assume_role {
    role_arn = "arn:aws:iam::601164058091:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "fogg-org"
  assume_role {
    role_arn = "arn:aws:iam::328216504962:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "fogg-asset"
  assume_role {
    role_arn = "arn:aws:iam::060659916753:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "fogg-circus"
  assume_role {
    role_arn = "arn:aws:iam::844609041254:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "fogg-data"
  assume_role {
    role_arn = "arn:aws:iam::624713464251:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "fogg-gateway"
  assume_role {
    role_arn = "arn:aws:iam::318746665903:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "fogg-home"
  assume_role {
    role_arn = "arn:aws:iam::812459563189:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "fogg-hub"
  assume_role {
    role_arn = "arn:aws:iam::337248635000:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "fogg-post"
  assume_role {
    role_arn = "arn:aws:iam::565963418226:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "fogg-sandbox"
  assume_role {
    role_arn = "arn:aws:iam::442766271046:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "fogg-security"
  assume_role {
    role_arn = "arn:aws:iam::372333168887:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "imma-org"
  assume_role {
    role_arn = "arn:aws:iam::548373030883:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "imma-amanibhavam"
  assume_role {
    role_arn = "arn:aws:iam::246197522468:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "imma-dgwyn"
  assume_role {
    role_arn = "arn:aws:iam::289716781198:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "imma-dev"
  assume_role {
    role_arn = "arn:aws:iam::445584037541:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "imma-prod"
  assume_role {
    role_arn = "arn:aws:iam::766142996227:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "imma-tolan"
  assume_role {
    role_arn = "arn:aws:iam::516851121506:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "immanent-org"
  assume_role {
    role_arn = "arn:aws:iam::545070380609:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "immanent-changer"
  assume_role {
    role_arn = "arn:aws:iam::003884504807:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "immanent-chanter"
  assume_role {
    role_arn = "arn:aws:iam::071244154667:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "immanent-doorkeeper"
  assume_role {
    role_arn = "arn:aws:iam::013267321144:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "immanent-ged"
  assume_role {
    role_arn = "arn:aws:iam::640792184178:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "immanent-hand"
  assume_role {
    role_arn = "arn:aws:iam::826250190242:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "immanent-herbal"
  assume_role {
    role_arn = "arn:aws:iam::165452499696:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "immanent-namer"
  assume_role {
    role_arn = "arn:aws:iam::856549015893:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "immanent-patterner"
  assume_role {
    role_arn = "arn:aws:iam::143220204648:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "immanent-roke"
  assume_role {
    role_arn = "arn:aws:iam::892560628624:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "immanent-summoner"
  assume_role {
    role_arn = "arn:aws:iam::397411277587:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "immanent-windkey"
  assume_role {
    role_arn = "arn:aws:iam::095764861781:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "whoa-org"
  assume_role {
    role_arn = "arn:aws:iam::389772512117:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "whoa-dev"
  assume_role {
    role_arn = "arn:aws:iam::439761234835:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "whoa-prod"
  assume_role {
    role_arn = "arn:aws:iam::204827926367:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "whoa-secrets"
  assume_role {
    role_arn = "arn:aws:iam::464075062390:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-org"
  assume_role {
    role_arn = "arn:aws:iam::730917619329:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-1"
  assume_role {
    role_arn = "arn:aws:iam::741346472057:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-2"
  assume_role {
    role_arn = "arn:aws:iam::447993872368:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-3"
  assume_role {
    role_arn = "arn:aws:iam::463050069968:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-4"
  assume_role {
    role_arn = "arn:aws:iam::368890376620:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-5"
  assume_role {
    role_arn = "arn:aws:iam::200733412967:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-6"
  assume_role {
    role_arn = "arn:aws:iam::493089153027:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-7"
  assume_role {
    role_arn = "arn:aws:iam::837425503386:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-8"
  assume_role {
    role_arn = "arn:aws:iam::773314335856:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-9"
  assume_role {
    role_arn = "arn:aws:iam::950940975070:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-a"
  assume_role {
    role_arn = "arn:aws:iam::503577294851:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-b"
  assume_role {
    role_arn = "arn:aws:iam::310940910494:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-c"
  assume_role {
    role_arn = "arn:aws:iam::047633732615:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-d"
  assume_role {
    role_arn = "arn:aws:iam::699441347021:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-e"
  assume_role {
    role_arn = "arn:aws:iam::171831323337:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-f"
  assume_role {
    role_arn = "arn:aws:iam::842022523232:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-g"
  assume_role {
    role_arn = "arn:aws:iam::023867963778:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-h"
  assume_role {
    role_arn = "arn:aws:iam::371020107387:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-i"
  assume_role {
    role_arn = "arn:aws:iam::290132238209:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-j"
  assume_role {
    role_arn = "arn:aws:iam::738433022197:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-k"
  assume_role {
    role_arn = "arn:aws:iam::580612865853:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-l"
  assume_role {
    role_arn = "arn:aws:iam::991300382347:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-m"
  assume_role {
    role_arn = "arn:aws:iam::684895750259:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-n"
  assume_role {
    role_arn = "arn:aws:iam::705881812506:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-o"
  assume_role {
    role_arn = "arn:aws:iam::307136835824:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-p"
  assume_role {
    role_arn = "arn:aws:iam::706168331526:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-q"
  assume_role {
    role_arn = "arn:aws:iam::217047480856:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-r"
  assume_role {
    role_arn = "arn:aws:iam::416221726155:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-s"
  assume_role {
    role_arn = "arn:aws:iam::840650118369:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-t"
  assume_role {
    role_arn = "arn:aws:iam::490895200523:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-u"
  assume_role {
    role_arn = "arn:aws:iam::467995590869:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-v"
  assume_role {
    role_arn = "arn:aws:iam::979368042862:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-w"
  assume_role {
    role_arn = "arn:aws:iam::313387692116:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-x"
  assume_role {
    role_arn = "arn:aws:iam::834936839208:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-y"
  assume_role {
    role_arn = "arn:aws:iam::153556747817:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "chamber-z"
  assume_role {
    role_arn = "arn:aws:iam::037804009879:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "jianghu-org"
  assume_role {
    role_arn = "arn:aws:iam::657613322961:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "jianghu-tahoe"
  assume_role {
    role_arn = "arn:aws:iam::025636091251:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "jianghu-klamath"
  assume_role {
    role_arn = "arn:aws:iam::298431841138:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "vault-org"
  assume_role {
    role_arn = "arn:aws:iam::475528707847:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "circus-org"
  assume_role {
    role_arn = "arn:aws:iam::036139182623:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "circus-audit"
  assume_role {
    role_arn = "arn:aws:iam::707476523482:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "circus-ops"
  assume_role {
    role_arn = "arn:aws:iam::415618116579:role/dfn-defn-terraform"
  }
}


provider "aws" {
  alias = "circus-transit"
  assume_role {
    role_arn = "arn:aws:iam::002516226222:role/dfn-defn-terraform"
  }
}