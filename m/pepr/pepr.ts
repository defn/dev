import { PeprModule } from "pepr";
import { DefnPepr } from "./capabilities/defn";
import cfg from "./package.json";

new PeprModule(cfg, [DefnPepr]);
