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
        uId: {
            default: null,
            type: cc.EditBox
        }
    },

    // use this for initialization
    onLoad: function () {
        //test
        // let url = "http://img3.redocn.com/tupian/20150312/haixinghezhenzhubeikeshiliangbeijing_3937174.jpg";
        // cc.loader.load(url,function (error,asset) {
        // })
    },
    login: function () {
        //调用登录方法，登录回调设置数据，在加载场景
        // global.player.id = this.uId.string;
        cc.director.loadScene("gameScence1.0.1");

    },
    // called every frame, uncomment this function to activate update callback
    // update: function (dt) {

    // },
});
