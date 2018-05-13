import UIKit
import Chatto
import ChattoAdditions
import PusherSwift
import Alamofire
import CodableAlamofire


class DemoChatViewController: BaseChatViewController {

    var messageSender: DemoChatMessageSender!
    let messagesSelector = BaseMessagesSelector()
    
    
    var type : Int = 1 //type Business , lets see ,friendly          ///////////ALL MODES
    
    var inviteID : Int?          ///////////INVITE MODE
    
    var targetId : Int?          ///////////CHAT MODE
    
    var isOneTextMode : Bool = false
    var isSendedOneMessage : Bool = false
    
    // MARK : -Pusher Channel
    var channelName : String = ""          ///////////CHAT MODE
    var options : PusherClientOptions?
    var pusher : Pusher?
    var pusherChannel : PusherChannel?
    
    
    var dataSource: DemoChatDataSource! {
        didSet {
            self.chatDataSource = self.dataSource
            self.messageSender = self.dataSource.messageSender
        }
    }

    lazy private var baseMessageHandler: BaseMessageHandler = {
        return BaseMessageHandler(messageSender: self.messageSender, messagesSelector: self.messagesSelector)
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ""
        self.messagesSelector.delegate = self
        self.chatItemsDecorator = DemoChatItemsDecorator(messagesSelector: self.messagesSelector)
        
        if(isSendedOneMessage && isOneTextMode){
            self.chatInputPresenter.chatInputBar.alpha = 0
            self.view.endEditing(true)
        }
        
        options = PusherClientOptions ( host: .cluster("mt1") )
        
        pusher = Pusher(
            key: "6a39f8875e90a2c2cec5",
            options: options!
        )
        pusher?.connect()
        
        pusherChannel = pusher?.subscribe(self.channelName)
        
        let _ = pusherChannel?.bind(eventName: "receive-message", callback: { (data: Any?) -> Void in
            if let data = data as? [String : AnyObject] {
                if let message = data["message"] as? String {
                    print(message)
                    self.dataSource.addIncommingTextMessage(message)
                }
            }
        })
        
        
    }
    


    var chatInputPresenter: BasicChatInputBarPresenter!
    override func createChatInputView() -> UIView {
        let chatInputView = ChatInputBar.loadNib()
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonAppearance.title = NSLocalizedString("Send", comment: "")
        appearance.textInputAppearance.placeholderText = NSLocalizedString("Type a message", comment: "")
        self.chatInputPresenter = BasicChatInputBarPresenter(chatInputBar: chatInputView, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
        chatInputView.maxCharactersCount = 1000
        return chatInputView
    }

    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {

        let textMessagePresenter = TextMessagePresenterBuilder(
            viewModelBuilder: DemoTextMessageViewModelBuilder(),
            interactionHandler: DemoTextMessageHandler(baseHandler: self.baseMessageHandler)
        )
        textMessagePresenter.baseMessageStyle = BaseMessageCollectionViewCellAvatarStyle()
        //1 => party , 2 => Business , 3 => LetsSee , 4 => Friendly
        
        if(type == 1){
            textMessagePresenter.textCellStyle = TextMessageCollectionViewCellFlintStyle.init(lineOutImg: "chat_line_out_P", lineInImg: "chat_line_P")
        }else if(type == 2){
            textMessagePresenter.textCellStyle = TextMessageCollectionViewCellFlintStyle.init(lineOutImg: "chat_line_out_B", lineInImg: "chat_line_B")
        }else if(type == 3){
            textMessagePresenter.textCellStyle = TextMessageCollectionViewCellFlintStyle.init(lineOutImg: "chat_line_out", lineInImg: "chat_line")
        }else if(type == 4){
            textMessagePresenter.textCellStyle = TextMessageCollectionViewCellFlintStyle.init(lineOutImg: "chat_line_out_F", lineInImg: "chat_line_F")
        }
        

        return [
            DemoTextMessageModel.chatItemType: [textMessagePresenter],
            SendingStatusModel.chatItemType: [SendingStatusPresenterBuilder()],
            TimeSeparatorModel.chatItemType: [TimeSeparatorPresenterBuilder()]
        ]
    }

    func createChatInputItems() -> [ChatInputItemProtocol] {
        var items = [ChatInputItemProtocol]()
        items.append(self.createTextInputItem())
        return items
    }

    private func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            self?.dataSource.addTextMessage(text)
            if(self?.isOneTextMode ?? false)!{
                self?.chatInputPresenter.chatInputBar.alpha = 0
                self?.view.endEditing(true)
                //inja bayad service rest call she
                self?.sendOneMessageModeToServer(txt: text)
            }else{
                //call send Message
                self?.sendMessageToServer(txt :text)
            }
            
        }
        return item
    }
    
    func sendOneMessageModeToServer(txt : String){
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.sendInviteMessage, method: .post , parameters: SendInviteMessageRequestModel.init(TEXT: txt, INVITE: self.inviteID!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            
            
        }
    }
    
    func sendMessageToServer(txt : String){
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.sendMessage, method: .post , parameters: SendMessageRequestModel.init(TEXT: txt, TARGET: self.targetId! ).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            
            
        }
    }

    private func createPhotoInputItem() -> PhotosChatInputItem {
        let item = PhotosChatInputItem(presentingController: self)
        item.photoInputHandler = { [weak self] image in
            self?.dataSource.addPhotoMessage(image)
        }
        return item
    }
}

extension DemoChatViewController: MessagesSelectorDelegate {
    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didSelectMessage: MessageModelProtocol) {
        self.enqueueModelUpdate(updateType: .normal)
    }

    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didDeselectMessage: MessageModelProtocol) {
        self.enqueueModelUpdate(updateType: .normal)
    }
}
