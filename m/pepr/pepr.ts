import { PeprModule } from "pepr";
import { UnicornPepr } from "./capabilities/unicorn";
import { DefnPepr } from "./capabilities/defn";
import cfg from "./package.json";

new PeprModule(cfg, [UnicornPepr, DefnPepr]);
