/**
 * Created by zhangyang on 17/8/10.
 * 广东麻将消息接收
 */
var Define = require("Define");

var GDMJ_Get_Define = {
    GS_MJ_PLAY: Define.GAME_STATUS_PLAY + 1,				//游戏状态
    GS_MJ_FREE: Define.GAME_STATUS_FREE,                 	//空闲状态
    SUB_S_GAME_START: 100,									//游戏开始
    SUB_S_OUT_CARD: 101,									//出牌命令
    SUB_S_SEND_CARD: 102,									//发送扑克
    SUB_S_OPERATE_NOTIFY: 104,									//操作提示
    SUB_S_OPERATE_RESULT: 105,									//操作命令
    SUB_S_GAME_END: 106,									//游戏结束
    SUB_S_TRUSTEE: 107,									//用户托管
    SUB_S_CHI_HU: 108,									//
    SUB_S_GANG_SCORE: 110,									//
    SUB_S_GENZHUANG: 111,								    //跟庄
    SUB_S_HUAFEN: 112,									//花
    SUB_GR_EXPRESSIONREPLY: 213,								    //表情消息回复
    SUB_GR_USER_CHAT: 211                                   //聊天消息
};


var GDMJ_Get_Struct = {

    //组合子项
    CMD_WeaveItem: {
        sum_len: 5,
        cbWeaveKind: 'byte',						//组合类型
        cbCenterCard: 'byte',						//中心扑克
        cbPublicCard: 'byte',				        //公开标志
        wProvideUser: 'tchar'				        //供应用户
    },

    //游戏状态
    CMD_S_StatusFree: {
        sum_len: 8 + 2 + 4 + 8 * 4,
        lCellScore: 'longlong',							//基础金币
        wBankerUser: 'tchar',						        //庄家用户
        bTrustee: 'byte&' + 4,				            //是否托管
        PrivateAllGameScore: 'longlong&' + 4
    },
    //游戏状态
    CMD_S_StatusPlay: {
        sum_len: 2 + 1 + 4 + 8 + 2 + 2 + 1 + 1 + 1 + 4 + 2 * 4 + 2 + 1 + 4 + 240 + 1 + 14 + 1 + 4,
        //游戏变量
        KindId: 'tchar',
        GameTypeIdex: 'byte',
        GameRuleIdex: 'int',
        lCellScore: 'longlong',				   //单元积分
        wBankerUser: 'tchar',					   //庄家用户
        wCurrentUser: 'tchar',					   //当前用户

        //状态变量
        cbActionCard: 'byte',						//动作麻将
        cbActionMask: 'byte',						//动作掩码
        cbLeftCardCount: 'byte',						//剩余数目
        bTrustee: 'byte&' + 4,			        //是否托管
        wWinOrder: 'tchar&' + 4,

        //出牌信息
        wOutCardUser: 'tchar',						//出牌用户
        cbOutCardData: 'byte',						//出牌麻将
        cbDiscardCount: 'byte&' + 4,		            //丢弃数目
        cbDiscardCard: 'byte&' + 60 * 4,		        //丢弃记录

        //麻将数据
        cbCardCount: 'byte',						//麻将数目
        cbCardData: 'byte&' + 14,			        //麻将列表
        cbSendCardData: 'byte',					    //发送麻将

        //组合麻将
        cbWeaveCount: 'byte&' + 4			        //组合数目
    },
    CMD_S_StatusPlay2: {
        sum_len: 20 + 32,
        MagicCard: 'byte&' + 8,		            //多百搭
        wLianZhuang: 'int&' + 2,
        m_HuaCount: 'byte&' + 4,					//花的次数
        PrivateAllGameScore: 'longlong&' + 4
    },

    //游戏开始
    CMD_S_GameStart: {
        sum_len: 2 + 1 + 4 + 4 + 2 + 2 + 1 + 56 + 1 + 1 + 8 + 8,
        KindId: 'tchar',
        GameTypeIdex: 'byte',
        GameRuleIdex: 'int',
        lSiceCount: 'int',							    //骰子点数
        wBankerUser: 'tchar',								//庄家用户
        wCurrentUser: 'tchar',                              //当前用户
        cbUserAction: 'byte',								//用户动作
        cbCardData: 'byte&' + 14 * 4,			            //扑克列表
        cbLeftCardCount: 'byte',
        cbXiaoHuTag: 'byte',								//起手胡
        MagicCard: 'byte&' + 8,						    //多百搭
        wLianZhuang: 'int&' + 2							//1位置 2分数
    },

    //出牌命令
    CMD_S_OutCard: {
        sum_len: 2 + 1,
        wOutCardUser: 'tchar',						        //出牌用户
        cbOutCardData: 'byte'						            //出牌扑克
    },

    //发送扑克
    CMD_S_SendCard: {
        sum_len: 1 + 1 + 2 + 1 + 1,
        cbCardData: 'byte',							    //扑克数据
        cbActionMask: 'byte',						        //动作掩码
        wCurrentUser: 'tchar',						        //当前用户
        bTail: "byte",							    //末尾发牌
        DealyDelete: 'byte'						        //延迟删除
    },
    //操作提示
    CMD_S_OperateNotify: {
        sum_len: 2 + 1 + 1,
        wResumeUser: 'tchar',						        //还原用户
        cbActionMask: 'byte',				                //动作掩码
        cbActionCard: 'byte'					                //动作扑克
    },

    //操作命令
    CMD_S_OperateResult: {
        sum_len: 2 + 2 + 1 + 1,
        wOperateUser: 'tchar',						        //操作用户
        wProvideUser: 'tchar',				                //供应用户
        cbOperateCode: 'byte',				                //操作代码
        cbOperateCard: 'byte'						            //操作扑克
    },

    //用户托管
    CMD_S_Trustee: {
        sum_len: 2 + 1,
        bTrustee: 'byte',						        //是否托管
        wChairID: 'tchar'						        //托管用户
    },


    CMD_S_ChiHu: {
        sum_len: 2 + 2 + 1 + 1 + 8 * 4 + 1,
        wChiHuUser: 'tchar',
        wProviderUser: 'tchar',
        cbChiHuCard: 'byte',
        cbCardCount: 'byte',
        lGameScore: 'longlong&' + 4,
        cbWinOrder: 'byte'
    },
    //花牌加分
    CMD_S_HuaScore: {
        sum_len: 1 + 1 + 1 + 1,
        wCharid: 'byte',						        //位置
        currentscore: 'byte',						        //当前
        addscore: 'byte',						        //添加
        CardData: 'byte'							        //花牌
    },
    //杠牌加分
    CMD_S_GangScore: {
        sum_len: 2 + 1 + 32,
        wChairId: 'tchar',
        cbXiaYu: 'byte',
        lGangScore: 'longlong&' + 4
    },

    CMD_S_GameEnd: {
        sum_len: 277,  // + 140 = 417    2+1+4+4+56+8+16+16+32+32+16+8+32+4+32+2+8+4
        KindId: 'tchar',
        GameTypeIdex: 'byte',
        GameRuleIdex: 'int',
        cbCardCount: 'byte&' + 4,
        cbCardData: 'byte&' + 4 * 14,
        //结束信息
        wProvideUser: 'tchar&' + 4,			              //供应用户
        dwChiHuRight: 'int&' + 4,			                  //胡牌类型
        dwStartHuRight: 'int&' + 4,		                      //起手胡牌类型
        lStartHuScore: 'longlong&' + 4,			          //起手胡牌分数
        //积分信息
        lGameScore: 'longlong&' + 4,			          //游戏积分
        lGameTax: 'int&' + 4,
        wWinOrder: 'tchar&' + 4,				          //胡牌排名
        lGangScoreInfo: 'longlong&' + 4,			          //详细得分
        cbGenCount: 'byte&' + 4,
        wLostFanShu: 'tchar&' + 4 * 4,
        wLeftUser: 'tchar',
        GameState: 'tchar&' + 4,
        cbWeaveCount: 'byte&' + 4					      //组合数目
    },

    CMD_S_GameEnd2: {
        sum_len: 20 + 1 + 1 + 20 + 4 + 2 + 4 + 4 + 4,   //60   80   417 - 140  = 277
        cbCardDataNiao: 'byte&' + 20,	                      //鸟牌
        cbNiaoCount: 'byte',	                          //鸟牌个数
        cbNiaoPick: 'byte',	                          //中鸟个数
        cbCardDataNiaoPick: 'byte&' + 20,	                      //鸟牌
        HuaCount: 'byte&' + 4,	                      //中花次数
        wFan: 'tchar',					          //胡牌番数
        cFangGangCount: 'byte&' + 4,
        cAnGangCount: 'byte&' + 4,
        cMingGangCount: 'byte&' + 4
    },
    //用户表情
    CMD_GR_S_UserExpression: {
        sum_len: 2 + 4 + 4 + 2 * 32 + 2 * 32 + 2 * 32 + 2 * 32,
        wItemIndex: 'tchar',						//表情索引
        dwSendUserID: 'int',						    //发送用户
        dwTargetUserID: 'int',				            //目标用户
        szSendUserNickName: 'tchar&' + 32,				    //发送用户昵称
        szSendUserUnderWrite: 'tchar&' + 32,			        //发送用户签名
        szTargetUserNickName: 'tchar&' + 32,			        //目标用户昵称
        szTargetUserUnderWrite: 'tchar&' + 32			        //目标用户签名
    },
    CMD_GR_S_UserChat: {
        sum_len: 4 + 2 * 128,
        dwSendUserID: 'int',                         //发送用户
        szChatString: 'tchar&' + 128		            //聊天信息
    }
};


var GDMJ_ScenceMessages_Play = [];
var GDMJ_ScenceMessages_Free = null;
var GDMaJiang_GetMessages = {};
//场景消息
GDMaJiang_GetMessages.handleMainFrameGameScene = function (buf, wBufLen) {
    cc.log("---------广东麻将场景消息-----------");
    var gameStatus = gm.user.getGameFrameStatus();
    cc.log("------------游戏状态---------" + gameStatus);
    if (gameStatus === GDMJ_Get_Define.GS_MJ_PLAY) {
        cc.log("----------------游戏状态消息结构------------");
        GDMaJiang_GetMessages.PlayState(buf, wBufLen);
    }
    if (gameStatus === GDMJ_Get_Define.GS_MJ_FREE) {
        cc.log("----------------游戏空闲状态消息结构------------");
        GDMaJiang_GetMessages.FreeState(buf, wBufLen);
    }
};

GDMaJiang_GetMessages.OnGameMessage = function (SubCmdID, Address, Length) {
    cc.log("---------广东麻将消息接收-----------" + SubCmdID);
    switch (SubCmdID) {
        case GDMJ_Get_Define.SUB_S_GAME_START: //游戏开始
            GDMaJiang_GetMessages.OnSubGameStart(Address, Length);
            break;
        case GDMJ_Get_Define.SUB_S_OUT_CARD:   //出牌命令
            GDMaJiang_GetMessages.OnSubOutCardOrder(Address, Length);
            break;
        case GDMJ_Get_Define.SUB_S_SEND_CARD:   //发送扑克
            GDMaJiang_GetMessages.OnSubOutCardData(Address, Length);
            break;
        case GDMJ_Get_Define.SUB_S_OPERATE_NOTIFY://操作提示
            GDMaJiang_GetMessages.OnSubOperateNotify(Address, Length);
            break;
        case GDMJ_Get_Define.SUB_S_OPERATE_RESULT://操作结果
            GDMaJiang_GetMessages.OnSubOperateResult(Address, Length);
            break;
        case GDMJ_Get_Define.SUB_S_GAME_END://游戏结束
            GDMaJiang_GetMessages.OnSubGameEnd(Address, Length);
            break;
        case GDMJ_Get_Define.SUB_S_TRUSTEE://用户托管
            GDMaJiang_GetMessages.OnSubTrustee(Address, Length);
            break;
        case GDMJ_Get_Define.SUB_GR_EXPRESSIONREPLY:
            GDMaJiang_GetMessages.Face(Address, Length);
            break;
        case GDMJ_Get_Define.SUB_S_HUAFEN:
            GDMaJiang_GetMessages.OnSubHuaFen(Address, Length);
            break;
        case GDMJ_Get_Define.SUB_S_GANG_SCORE:
            GDMaJiang_GetMessages.OnSubGangFen(Address, Length);
            break;
        case GDMJ_Get_Define.SUB_S_GENZHUANG:
            ShowDialogMessage("-----跟庄消息----");
            //GDMaJiang_GetMessages.OnSubGenZhuang(Address, Length);
            break;
        case GDMJ_Get_Define.SUB_S_CHI_HU:
            GDMaJiang_GetMessages.OnSubChiHu(Address, Length);
            break;
        case Private_SUB_USER_LUCKDRAW:
            cc.log("=======宝箱=========")
            var data = GetDataByStructWithNoSumLen(Address, Length, Private_CMD_GF_USERLUCKDRAW);
            if (data.isFirst == 0) {
                gDispatchEvt(gm.EventName.OPEN_CHEST, data);
            } else {
                gDispatchEvt(gm.EventName.GET_LUCK, data);
            }
            break;
        case GDMJ_Get_Define.SUB_GR_USER_CHAT:
            GDMaJiang_GetMessages.Talk(Address, Length);
            break;
    }
};
GDMaJiang_GetMessages.FreeState = function (buf, wBufLen) {
    var data = GetDataByStructWithNoSumLen(buf, wBufLen, GDMJ_Get_Struct.CMD_S_StatusFree);
    logStruct(data);
    GDMJ_ScenceMessages_Free = data;
};


GDMaJiang_GetMessages.PlayState = function (buf, wBufLen) {
    var data1 = GetDataByStructWithNoSumLen(buf, wBufLen, GDMJ_Get_Struct.CMD_S_StatusPlay);
    logStruct(data1);
    //场景消息保存
    GDMJ_ScenceMessages_Play.push(data1);

    //动作组合
    var data2 = GetDataArrayByStruct(buf + GDMJ_Get_Struct.CMD_S_StatusPlay.sum_len, GDMJ_Get_Struct.CMD_WeaveItem.sum_len * 16, GDMJ_Get_Struct.CMD_WeaveItem);
    logStruct(data2);
    GDMJ_ScenceMessages_Play.push(data2);

    //剩余两个
    var data3 = GetDataWithHeadLength(GDMJ_Get_Struct.CMD_S_StatusPlay.sum_len + 80, wBufLen, buf, GDMJ_Get_Struct.CMD_S_StatusPlay2);
    logStruct(data3);
    GDMJ_ScenceMessages_Play.push(data3);
};

//游戏开始
GDMaJiang_GetMessages.OnSubGameStart = function (Address, Length) {
    cc.log("--------麻将开始消息--------");
    var data = GetDataByStructWithNoSumLen(Address, Length, GDMJ_Get_Struct.CMD_S_GameStart);
    gDispatchEvt(gm.EventName.GDMaJiang_GameStart, data);
};

//出牌命令  用户打出的一张牌
GDMaJiang_GetMessages.OnSubOutCardOrder = function (Address, Length) {
    cc.log("--------用户打出的一张牌--------");
    var data = GetDataByStructWithNoSumLen(Address, Length, GDMJ_Get_Struct.CMD_S_OutCard);
    logStruct(data);
    gDispatchEvt(gm.EventName.GDMaJiang_OutCard, data);
};


//发送扑克  用户抓到的一张牌
GDMaJiang_GetMessages.OnSubOutCardData = function (Address, Length) {
    cc.log("--------用户抓到的一张牌--------");
    var data = GetDataByStructWithNoSumLen(Address, Length, GDMJ_Get_Struct.CMD_S_SendCard);
    logStruct(data);
    gDispatchEvt(gm.EventName.GDMaJiang_GetCard, data);
};

//操作提示
GDMaJiang_GetMessages.OnSubOperateNotify = function (Address, Length) {
    cc.log("----------操作提示----------")
    cc.log(Address);
    cc.log(Length);
    var data = GetDataByStructWithNoSumLen(Address, Length, GDMJ_Get_Struct.CMD_S_OperateNotify);
    logStruct(data);
    gDispatchEvt(gm.EventName.GDMaJiang_OperateCard, data);
};

//操作结果
GDMaJiang_GetMessages.OnSubOperateResult = function (Address, Length) {
    cc.log("---------操作结果----------");
    cc.log(Address);
    cc.log(Length);
    var data = GetDataByStructWithNoSumLen(Address, Length, GDMJ_Get_Struct.CMD_S_OperateResult);
    logStruct(data);
    gDispatchEvt(gm.EventName.GDMaJiang_OperateCardResult, data);
};

//游戏结束
GDMaJiang_GetMessages.OnSubGameEnd = function (Address, Length) {
    cc.log("---------游戏结束----------");

    var data1 = GetDataByStructWithNoSumLen(Address, Length, GDMJ_Get_Struct.CMD_S_GameEnd);
    logStruct(data1);

    //动作组合
    var data2 = GetDataArrayByStruct(Address + GDMJ_Get_Struct.CMD_S_GameEnd.sum_len, GDMJ_Get_Struct.CMD_WeaveItem.sum_len * 16, GDMJ_Get_Struct.CMD_WeaveItem);
    logStruct(data2);

    for (var i = 0; i < 16; i++) {
        logStruct(data2[i]);
    }

    //剩余两个
    var data3 = GetDataWithHeadLength(GDMJ_Get_Struct.CMD_S_GameEnd.sum_len + 80, Length, Address, GDMJ_Get_Struct.CMD_S_GameEnd2);
    logStruct(data3);

    var data = [data1, data2, data3];
    gDispatchEvt(gm.EventName.GDMaJiang_GameEnd, data);
};
//杠牌加分
GDMaJiang_GetMessages.OnSubGangFen = function (Address, Length) {
    cc.log("---------杠牌加分---------");
    var data = GetDataByStructWithNoSumLen(Address, Length, GDMJ_Get_Struct.CMD_S_GangScore);
    gDispatchEvt(gm.EventName.GDMaJiang_GangFen, data);
};

//补花加分
GDMaJiang_GetMessages.OnSubHuaFen = function (Address, Length) {
    cc.log("---------补花加分---------");
    var data = GetDataByStructWithNoSumLen(Address, Length, GDMJ_Get_Struct.CMD_S_HuaScore);
    gDispatchEvt(gm.EventName.GDMaJiang_HuaFen, data);
};

//跟庄加分
// GDMaJiang_GetMessages.OnSubGenZhuang = function (Address, Length){
//     cc.log("---------补花加分---------");
//     var data = GetDataByStructWithNoSumLen(Address, Length, GDMJ_Get_Struct.CMD_S_HuaScore);
//     logStruct(data);
//     ShowDialogMessage("补花加分")
// };

GDMaJiang_GetMessages.OnSubChiHu = function (Address, Length) {
    cc.log("---------吃胡操作---------");
    var data = GetDataByStructWithNoSumLen(Address, Length, GDMJ_Get_Struct.CMD_S_ChiHu);
    logStruct(data);
    ChiHuData = data;
};

//用户托管
GDMaJiang_GetMessages.OnSubTrustee = function (Address, Length) {
    cc.log("---------用户托管---------");
};

GDMaJiang_GetMessages.Face = function (Address, Length) {
    cc.log("----------用户表情--------");
    var data = GetDataByStructWithNoSumLen(Address, Length, GDMJ_Get_Struct.CMD_GR_S_UserExpression);
    logStruct(data);
    gDispatchEvt(gm.EventName.GDMaJiang_Face, data);
};
GDMaJiang_GetMessages.Talk = function (Address, Length) {
    cc.log("----------用户聊天------------");
    var data = GetDataByStructWithNoSumLen(Address, Length, GDMJ_Get_Struct.CMD_GR_S_UserChat);
    logStruct(data);
    gDispatchEvt(gm.EventName.GDMaJiang_Talk, data);
};


