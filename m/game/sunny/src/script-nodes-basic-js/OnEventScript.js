
// You can write more code here

/* START OF COMPILED CODE */

class OnEventScript extends ScriptNode {

	constructor(parent) {
		super(parent);

		/* START-USER-CTR-CODE */
		/* END-USER-CTR-CODE */
	}

	/** @type {string} */
	eventName = "";
	/** @type {"game.events"|"scene.events"|"scene.loader"|"scene.input"|"scene.input.keyboard"|"scene.anims"|"gameObject"} */
	eventEmitter = "gameObject";
	/** @type {boolean} */
	once = false;

	/* START-USER-CODE */

	awake() {

		/** @type {Phaser.Events.EventEmitter | null | undefined} */
		let emitter;

		switch (this.eventEmitter) {
			case "game.events":

				emitter = this.scene.game.events;
				break;

			case "scene.events":

				emitter = this.scene.events;
				break;

			case "scene.loader":

				emitter = this.scene.load;
				break;

			case "scene.input":

				emitter = this.scene.input;
				break;

			case "scene.input.keyboard":

				emitter = this.scene.input.keyboard;
				break;

			case "scene.anims":

				emitter = this.scene.anims;
				break;

			case "gameObject":

				emitter = this.gameObject;
				break;
		}

		if (emitter) {

			if (this.once) {

				emitter.once(this.eventName, this.executeChildren, this);

			} else {

				emitter.on(this.eventName, this.executeChildren, this);
			}

			switch (this.eventEmitter) {
				case "scene.anims":
				case "scene.events":
				case "scene.input":
				case "scene.input.keyboard":
				case "scene.loader":

					this.scene.events.on(Phaser.Scenes.Events.SHUTDOWN, () => {

						emitter?.off(this.eventName, this.executeChildren, this);
					});
					break;
			}
		}
	}

	/* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
