cc.Class({
    extends: cc.Component,

    properties: {
        // foo: {
        //    default: null,      // The default value will be used only when the component attaching
        //                           to a node for the first time
        //    url: cc.Texture2D,  // optional, default is typeof default
        //    serializable: true, // optional, default is true
        //    visible: true,      // optional, default is true
        //    displayName: 'Foo', // optional
        //    readonly: false,    // optional, default is false
        // },
        // ...
    },

    // use this for initialization
    onLoad: function () {
        // this.showWaitingLayer();
    },
    // called every frame, uncomment this function to activate update callback
    update: function (dt) {

    },
    /**
     * 在任意位置调用该方法，显示加载动图
     * 要求：场景下第一个节点必定是canvas[名字没关系]，与其锚点和坐标有关系
     */
    showWaitingLayer: function () {
        cc.loader.loadRes("prefabs/waiting", function (error, asset) {
            var waitingNode = cc.instantiate(asset)
            var canvas = cc.director.getScene().children[0];
            // waitingNode.x = canvas.x;
            // waitingNode.y = canvas.y;
            canvas.addChild(waitingNode);
        }.bind(this))
    },
});
