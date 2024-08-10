import { PeprModule } from "pepr";
import cfg from "./package.json";
import { HelloPepr } from "./capabilities/hello";

new PeprModule(cfg, [HelloPepr]);
