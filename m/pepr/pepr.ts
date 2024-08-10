import { PeprModule } from "pepr";
import { HelloPepr } from "./capabilities/hello";

import cfg from "./package.json";

new PeprModule(cfg, [HelloPepr]);
