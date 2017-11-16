/**
 * Created by zhangyang on 17/8/10.
 * 广东麻将发送消息
 */
var Define = require("Define");


var GDMJ_Send_define = {
    SUB_C_OUT_CARD: 1,									//出牌命令
    SUB_C_OPERATE_CARD: 3,									//操作扑克
    SUB_C_TRUSTEE: 4,									//用户托管
    SUB_C_TEST_CARD: 6,									//测试换牌项目
    SUB_C_TEST_CARD2: 7,									//测试换牌项目2
    SUB_GR_GAME_EXPRESSION: 212,								//表情消息
    SUB_GR_USER_CHAT: 211                                   //聊天消息
};


var GDMJ_Send_Struct = {
    //出牌命令
    CMD_C_OutCard:
        {
            sum_len: 1,
            cbCardData: 'byte'							//扑克数据
        },

    //操作命令
    CMD_C_OperateCard:
        {
            sum_len: 1 + 1,
            cbOperateCode: 'byte',						//操作代码
            cbOperateCard: 'byte'						    //操作扑克
        },

    //用户托管
    CMD_C_Trustee:
        {
            sum_len: 1,
            bTrustee: 'byte'							//是否托管
        },

    //起手小胡
    CMD_C_XiaoHu:
        {
            sum_len: 1 + 1,
            cbOperateCode: 'byte',						//操作代码
            cbOperateCard: 'byte'						    //操作扑克
        },
    //用户表情
    CMD_GR_C_UserExpression:
        {
            sum_len: 2 + 4,
            wItemIndex: 'tchar',						//表情索引
            dwTargetUserID: 'int'						    //目标用户
        },
    //用户聊天
    CMD_GR_C_UserChat:
        {
            sum_len: 2 + 4 + 4 + 2 * Define.LEN_USER_CHAT,
            wChatLength: 'word',						//信息长度
            dwChatColor: 'int',						    //信息颜色
            dwTargetUserID: 'int',					        //目标用户
            szChatString: 'tchar&' + Define.LEN_USER_CHAT		    //聊天信息
        }
};


///////////////////////////////////////////////////////////////////////////////
/////////////////////////               ///////////////////////////////////////
/////////////////////////   游戏消息操作  ///////////////////////////////////////
/////////////////////////               ///////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

var GDMaJiang_SendMessages = {};

//出牌
GDMaJiang_SendMessages.SendCard = function (cbCardData) {
    var data = ConstructData(GDMJ_Send_Struct.CMD_C_OutCard);
    data.cbCardData = cbCardData;						       //扑克数据
    cc.log("-----出牌数据:" + data.cbCardData);
    GameSendData(GDMJ_Send_define.SUB_C_OUT_CARD, data, GDMJ_Send_Struct.CMD_C_OutCard);
};
//操作扑克 吃碰杠
GDMaJiang_SendMessages.OperationCard = function (cbOperateCode, cbOperateCard) {
    var data = ConstructData(GDMJ_Send_Struct.CMD_C_OperateCard);
    data.cbOperateCode = cbOperateCode;					    //操作代码
    data.cbOperateCard = cbOperateCard;					    //操作扑克
    GameSendData(GDMJ_Send_define.SUB_C_OPERATE_CARD, data, GDMJ_Send_Struct.CMD_C_OperateCard);
};

//用户托管
GDMaJiang_SendMessages.TrusteeCard = function (bTrustee) {
    var data = ConstructData(GDMJ_Send_Struct.CMD_C_Trustee);
    data.bTrustee = bTrustee;					            //是否托管
    GameSendData(GDMJ_Send_define.SUB_C_TRUSTEE, data, GDMJ_Send_Struct.CMD_C_Trustee);
};

//胡
GDMaJiang_SendMessages.TrusteeCard = function (cbOperateCode, cbOperateCard) {
    var data = ConstructData(GDMJ_Send_Struct.CMD_C_XiaoHu);
    data.cbOperateCode = cbOperateCode;						//操作代码
    data.cbOperateCard = cbOperateCard;					    //操作扑克
    GameSendData(GDMJ_Send_define.SUB_C_OPERATE_CARD, data, GDMJ_Send_Struct.CMD_C_XiaoHu);
};

//表情
GDMaJiang_SendMessages.Face = function (faceid) {
    var data = ConstructData(GDMJ_Send_Struct.CMD_GR_C_UserExpression);
    data.wItemIndex = faceid;						//操作代码
    data.dwTargetUserID = 0;					        //操作扑克
    GameSendData(GDMJ_Send_define.SUB_GR_GAME_EXPRESSION, data, GDMJ_Send_Struct.CMD_GR_C_UserExpression);
};

//聊天
GDMaJiang_SendMessages.Talk = function (chat) {
    var data = ConstructData(GDMJ_Send_Struct.CMD_GR_C_UserChat);
    data.wChatLength = chat.length;					//信息长度
    data.dwChatColor = 0;						    //信息颜色
    data.dwTargetUserID = 0;					        //目标用户
    data.szChatString = Global_NetWork.utf8to16(chat);		                    //聊天信息
    GameSendData(GDMJ_Send_define.SUB_GR_USER_CHAT, data, GDMJ_Send_Struct.CMD_GR_C_UserChat);
};

// m_cbCardDataArray144= [
//     0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09,						//同子
//     0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09,						//同子
//     0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09,						//同子
//     0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09,						//同子
//     0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19,						//万子
//     0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19,						//万子
//     0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19,						//万子
//     0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19,						//万子
//     0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29,						//索子
//     0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29,						//索子
//     0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29,						//索子
//     0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29,						//索子
//     0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,									//东南西北中发白
//     0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,									//东南西北中发白
//     0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,									//东南西北中发白
//     0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,									//东南西北中发白
//     0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48								//春夏秋冬梅兰竹菊
// ];
