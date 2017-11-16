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
        uId: '963158',
        uName: '九五之尊',
        uImg: {
            default: null,
            type: cc.SpriteFrame
        },
        uImgUrl: '', //获取微信等连接的图像
        gold: 0, //黄金
        silver: 0,//白银
        level: 0,

        status: 0,//状态-> 占座位：0准备，1站立；不占座位-> 2围观
        loginType: 0,

        myReceSeat: {
            default: null,
            type: cc.Node
        },
        mySendSeat: {
            default: null,
            type: cc.Node
        },

    },

    // use this for initialization
    onLoad: function () {

    },

    // called every frame, uncomment this function to activate update callback
    // update: function (dt) {

    // },
});
