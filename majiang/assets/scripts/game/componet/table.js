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
        timer: {
            default: null,
            type: cc.Node
        },
        receSeat: {//长度为4： 0-3 对应下，右，上，左
            default: [],
            type: cc.Node
        },
        sendSeat: {
            default: [],
            type: cc.Node
        },
        players: {
            default: [],
            type: cc.Node
        },
        peng: {
            default: null,
            type: cc.Node
        },
        gang: {
            default: null,
            type: cc.Node
        },
        hu: {
            default: null,
            type: cc.Node
        },
        buttonsPan: {
            default: null,
            type: cc.Node
        },
        buttons: {
            default: [],
            type: cc.Node
        },
        animalCardTab: {
            default: null,
            type: cc.Node
        }
    },

    // use this for initialization
    onLoad: function () {

    },

    // called every frame, uncomment this function to activate update callback
    // update: function (dt) {

    // },
});
