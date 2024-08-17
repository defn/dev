import { PeprModule } from "pepr";
import { HelloPepr } from "./capabilities/hello";
import { DefnPepr } from "./capabilities/defn";
import cfg from "./package.json";

new PeprModule(cfg, [HelloPepr, DefnPepr]);
