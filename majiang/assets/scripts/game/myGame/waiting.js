/**
 *  全局的等待层
 */
cc.Class({
    extends: cc.Component,
    properties: {
        target: cc.Node,
        // foo: {
        //    default: null,
        //    url: cc.Texture2D,  // optional, default is typeof default
        //    serializable: true, // optional, default is true
        //    visible: true,      // optional, default is true
        //    displayName: 'Foo', // optional
        //    readonly: false,    // optional, default is false
        // },
        // ...
        isShow: false, //初始化是否显示
        title: cc.Label,//标题
        target: cc.Node, //旋转节点
    },

    // use this for initialization
    onLoad: function () {
        this.node.active = this.isShow;
        this.show(null);
    },

    // called every frame, uncomment this function to activate update callback
    update: function (dt) {
        this.target.rotation = this.target.rotation - 3 * dt * 45;
    },

    show: function (content) {
        this.isShow = true;
        if (this.node) {
            this.node.active = this.isShow;
        }
        if (this.title) {
            if (content == null) {
                content = "请耐心等待";
            }
            this.title.string = content;
        }
        if (this.isMask) {
            this.mask.active = true;
        }
    },
    hide: function () {
        this.isShow = false;
        if (this.node) {
            this.node.active = this.isShow;
        }
    }
});
