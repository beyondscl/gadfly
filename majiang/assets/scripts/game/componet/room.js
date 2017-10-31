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
        roomId: {
            default: null,
            type: cc.Label
        },
        roomType: {
            default: null,
            type: cc.Label
        },
        roomLocation: '',
        playerMax: 4,//最多多少人，除了玩家还有围观的人
        // currPlayers:0,//当前有几个用户，
        readyToStart: true,
        //setting 以后再加了
    },

    // use this for initialization
    onLoad: function () {

    },

    // called every frame, uncomment this function to activate update callback
    // update: function (dt) {

    // },
});
