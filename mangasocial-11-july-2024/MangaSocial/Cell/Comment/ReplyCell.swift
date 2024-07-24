//
//  ReplyCell.swift
//  MangaSocial
//
//  Created by ATULA on 05/02/2024.
//

import UIKit

class ReplyCell: UICollectionViewCell, UITextViewDelegate {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var whiteLine: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var reply: UITextView!
    @IBOutlet weak var postComment: UIButton!
    
    var idRep: Int = 0
    
    var postHandler : (()->())?
    var deleteHandler: (()->())?
    var scroll: (()->())?
    var linkChapter: String = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.makeRounded()
        reply.delegate = self
        
        
        userAvatar.makeRounded()
        reply.layer.cornerRadius = 15.0
        reply.layer.masksToBounds = true
        
        postComment.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        postComment.layer.cornerRadius = 8

        

        reply.text = "Post your comment"
        reply.textColor = UIColor.lightGray
        
        postComment.isEnabled = false
        
    }
    
    func done() {
        APIService.shared.replyComment(content: reply.text!, idComment: idRep){ data, error in
            DispatchQueue.main.async { [self] in
                reply.text = ""
                postHandler?()
            }
            
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scroll?()
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
        postComment.isEnabled = true

    }
    
    @IBAction func deleteComment() {
        deleteHandler?()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Post your comment"
            textView.textColor = UIColor.lightGray
            postComment.isEnabled = false
        } else {
            postComment.isEnabled = true
        }
    }
    
    
    @IBAction func sendTextfield() {
        done()
    }

}
