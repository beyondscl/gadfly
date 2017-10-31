cc.Class({
    extends: cc.Component,

    properties: {
        resFlag: 0,
    },

    // use this for initialization
    onLoad: function () {
        console.log("开始加载麻将资源！！！！！");
        this.loadResDir("/images/GameScence/", cc.SpriteFrame);
        this.loadResDir("/player_img", cc.SpriteFrame);
        this.loadResDir("/prefabs", cc.Prefab);
    },
    loadResDir: function (Url, Type) {
        cc.loader.loadResDir(Url, Type, function (Error, Assets) {
            this.resFlag += 1;
            cc.log("加载完成:" + Url);
        }.bind(this));
    },
    loadRes: function (Url, Type) {
        cc.loader.loadRes(Url, Type, function (Error, Assets) {
            this.resFlag += 1;
            cc.log("加载完成:" + Url);
        }.bind(this));
    },
    //不建议使用,除非你确定所有资源已经加载，否则还是用回调！
    getRes: function (Url, Type) {
        var res = cc.loader.getRes(Url, Type);// 返回已经加载了的资源
        if (res) {
            return res;
        }
        // var realUrl = cc.url.raw("resources"+Url);// 路径加后缀 a.jpg
        // var texture = cc.textureCache.addImage(realUrl);
        // if (texture) {
        //     return texture;
        // }
        cc.log("资源无法获取:" + Url + ",尝试加载!");
        this.loadRes(Url, Type);
    },
    // called every frame, uncomment this function to activate update callback
    update: function (dt) {
        if (this.resFlag == 3) {
            this.resFlag = 0;
            GLOBAL.MAJIANG_RES = true;
            console.log("资源全部加载完成，加载游戏");
            this.node.getComponent("gameStart").initCB();
        }
    }
});
