/******************************************************************************
 * Spine Runtimes License Agreement
 * Last updated September 24, 2021. Replaces all prior versions.
 *
 * Copyright (c) 2013-2021, Esoteric Software LLC
 *
 * Integration of the Spine Runtimes into software or otherwise creating
 * derivative works of the Spine Runtimes is permitted under the terms and
 * conditions of Section 2 of the Spine Editor License Agreement:
 * http://esotericsoftware.com/spine-editor-license
 *
 * Otherwise, it is permitted to integrate the Spine Runtimes into software
 * or otherwise create derivative works of the Spine Runtimes (collectively,
 * "Products"), provided that each user of the Products must obtain their own
 * Spine Editor license and redistribution of the Products in any form must
 * include this license and copyright notice.
 *
 * THE SPINE RUNTIMES ARE PROVIDED BY ESOTERIC SOFTWARE LLC "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL ESOTERIC SOFTWARE LLC BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES,
 * BUSINESS INTERRUPTION, OR LOSS OF USE, DATA, OR PROFITS) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THE SPINE RUNTIMES, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *****************************************************************************/
declare namespace Phaser.Loader {
    interface LoaderPlugin {
        spineJson(key: string, url: string, xhrSettings?: Phaser.Types.Loader.XHRSettingsObject): LoaderPlugin;
        spineBinary(key: string, url: string, xhrSettings?: Phaser.Types.Loader.XHRSettingsObject): LoaderPlugin;
        spineAtlas(key: string, url: string, premultipliedAlpha?: boolean, xhrSettings?: Phaser.Types.Loader.XHRSettingsObject): LoaderPlugin;
    }
}
declare namespace Phaser.GameObjects {
    interface GameObjectFactory {
        spine(x: number, y: number, dataKey: string, atlasKey: string, boundsProvider?: spine.SpineGameObjectBoundsProvider): spine.SpineGameObject;
    }
    interface GameObjectCreator {
        spine(config: spine.SpineGameObjectConfig, addToScene?: boolean): spine.SpineGameObject;
    }
}
declare namespace Phaser {
    interface Scene {
        spine: spine.SpinePlugin;
    }
}
