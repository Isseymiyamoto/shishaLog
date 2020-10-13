//
//  UserPolicyController.swift
//  shishaLog
//
//  Created by 宮本一成 on 2020/08/20.
//  Copyright © 2020 ISSEY MIYAMOTO. All rights reserved.
//

import UIKit

protocol UserPolicyControllerDelegate: class {
    func handleBackRegister(_ UserPolicyView: UserPolicyController)
}

class UserPolicyController: UIViewController{
    
    // MARK: - Properties
    weak var delegate: UserPolicyControllerDelegate?
    
    private let userPolicyTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.isScrollEnabled = true
        tv.isEditable = false
        tv.isSelectable = false
        tv.textContainerInset = UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16)
        tv.sizeToFit()
        return tv
    }()
    
    private lazy var disagreeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("同意しない", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleDisagree), for: .touchUpInside)
        return button
    }()
    
    private lazy var consensusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("同意する", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleAgreeUserPolicy), for: .touchUpInside)
        return button
    }()
    
    private lazy var underButtonView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
 
    // MARK: - Selectors
    
    @objc func handleAgreeUserPolicy(){
        print("DEBUG: 反応あり in UserPolicyController")
        delegate?.handleBackRegister(self)
    }
    
    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDisagree(){
        print("DEBUG: 反応はしてるんよ")
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func configure(){
        
        setUserPolicyString()
        configureNavigationBar()
        
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(underButtonView)
        underButtonView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, height: 48)
        
        let stack = UIStackView(arrangedSubviews: [disagreeButton, consensusButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalCentering
        
        view.addSubview(stack)
        stack.centerY(inView: underButtonView)
        stack.anchor(left: underButtonView.leftAnchor, right: underButtonView.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(userPolicyTextView)
        userPolicyTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: underButtonView.topAnchor, right: view.rightAnchor)
        
    }
    
    func configureNavigationBar(){
        navigationItem.title = "利用規約"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    func setUserPolicyString(){
        userPolicyTextView.text = "Shisha Log 利用規約\n\nこの規約（以下「本規約」といいます。）は、宮本一成（以下「当社」といいます。）が提供する Shisha Log に関するすべての製品およびサービス（以下「本サービス」といいます。）の利用に関する条件を、本サービスを利用するお客様（以下「お客様」といいます。）と当社との間で定めるものです。\n\n1. 定義 \n\n本規約では、以下の用語を使用します。 \n\n1.1. 「コンテンツ」とは、文章、音声、音楽、画像、動画、ソフトウェア、プログラム、コードその他の情報のことをいいます。 \n1.2. 「本コンテンツ」とは、本サービスを通じてアクセスすることができるコンテンツのことをいいます。\n1.3. 「投稿コンテンツ」とは、お客様が本サービスに投稿、送信、アップロードしたコンテンツのことをいいます。\n1.4. 「個別利用規約」とは、本サービスに関して、本規約とは別に「規約」、「ガイドライン」、「ポリシー」などの名称で当社が配布または掲示している文書のことをいいます。\n\n2. 規約への同意 \n\n2.1 お客様は、本規約の定めに従って本サービスを利用しなければなりません。お客様は、本規約に有効かつ取消不能な同意をしないかぎり本サービスを利用できません。\n2.2. お客様が未成年者である場合は、親権者など法定代理人の同意を得たうえで本サービスを利用してください。また、お客様が本サービスを事業者のために利用する場合は、当該事業者も本規約に同意したうえで本サービスを利用してください。\n2.3. お客様は、本サービスを実際に利用することによって本規約に有効かつ取消不能な同意をしたものとみなされます。\n2.4. 本サービスにおいて個別利用規約がある場合、お客様は、本規約のほか個別利用規約の定めにも従って本サービスを利用しなければなりません。\n\n3. 規約の変更\n\n当社は、当社が必要と判断する場合、あらかじめお客様に通知することなく、いつでも、本規約および個別利用規約を変更できるものとします。変更後の本規約および個別利用規約は、当社が運営するウェブサイト内の適宜の場所に掲示された時点からその効力を生じるものとし、お客様は本規約および個別利用規約の変更後も本サービスを使い続けることにより、変更後の本規約および適用のある個別利用規約に対する有効かつ取消不能な同意をしたものとみなされます。かかる変更の内容をお客様に個別に通知することはいたしかねますので、本サービスをご利用の際には、随時、最新の本規約および適用のある個別利用規約をご参照ください。\n\n4. アカウント\n\n4.1. お客様は、本サービスの利用に際してお客様ご自身に関する情報を登録する場合、真実、正確かつ完全な情報を提供しなければならず、常に最新の情報となるよう修正しなければなりません。\n4.2. お客様は、本サービスの利用に際してパスワードを登録する場合、これを不正に利用されないようご自身の責任で厳重に管理しなければなりません。当社は、登録されたパスワードを利用して行なわれた一切の行為を、お客様ご本人の行為とみなすことができます。\n4.3. 本サービスに登録したお客様は、いつでもアカウントを削除して退会することができます。\n4.4. 当社は、お客様が本規約に違反しまたは違反するおそれがあると認めた場合、あらかじめお客様に通知することなく、アカウントを停止または削除することができます。\n4.5. 当社は、最終のアクセスから１年間以上経過しているアカウントを、あらかじめお客様に通知することなく削除することができます。\n4.6. お客様の本サービスにおけるすべての利用権は、理由を問わず、アカウントが削除された時点で消滅します。お客様が誤ってアカウントを削除した場合であっても、アカウントの復旧はできませんのでご注意ください。\n4.7. 本サービスのアカウントは、お客様に一身専属的に帰属します。お客様の本サービスにおけるすべての利用権は、第三者に譲渡、貸与または相続させることはできません。\n\n5.　プライバシー\n\n5.1. 当社は、お客様のプライバシーを尊重しています。\n5.2. 当社は、お客様のプライバシー情報と個人情報を、Shisha Log プライバシーポリシーに従って適切に取り扱います。\n5.3.当社は、お客様から収集した情報を安全に管理するため、セキュリティに最大限の注意を払っています。\n\n6. サービスの提供\n\n6.1. お客様は、本サービスを利用するにあたり、必要なパーソナルコンピュータ、携帯電話機、通信機器、オペレーションシステム、通信手段および電力などを、お客様の費用と責任で用意しなければなりません。\n6.2. 当社は、本サービスの全部または一部を、年齢、ご本人確認の有無、登録情報の有無、その他、当社が必要と判断する条件を満たしたお客様に限定して提供することができるものとします。\n6.3. 当社は、当社が必要と判断する場合、あらかじめお客様に通知することなく、いつでも、本サービスの全部または一部の内容を変更し、また、その提供を中止することができるものとします。\n\n7. 広告表示\n\n当社は、本サービスに当社または第三者の広告を掲載することができるものとします。\n\n8. 提携パートナーのサービス\n\n本サービスは、当社と提携する他の事業者が提供するサービスまたはコンテンツを含む場合があります。かかるサービスまたはコンテンツに対する責任は、これを提供する事業者が負います。また、かかるサービスまたはコンテンツには、これを提供する事業者が定める利用規約その他の条件が適用されることがあります。\n\n9.　コンテンツ\n\n9.1. 当社は、当社が提供する本コンテンツについて、お客様に対し、譲渡および再許諾できず、非独占的な、本サービスの利用を唯一の目的とする利用権を付与します。\n9.2. お客様は、利用料、利用期間等の利用条件が別途定められた本コンテンツを利用する場合、かかる利用条件に従うものとします。本サービスの画面上で「購入」、「販売」などの表示がされている場合であっても、当社がお客様に対し提供する本コンテンツに関する知的財産権その他の権利はお客様に移転せず、お客様には、上記の利用権のみが付与されます。\n9.3. お客様は、本コンテンツを、本サービスが予定している利用態様を超えて利用(複製、送信、転載、改変などの行為を含みます。)してはなりません。\n9.4. 投稿コンテンツのバックアップは、お客様ご自身で行なっていただくこととなります。当社は投稿コンテンツのバックアップを行う義務を負いません。\n9.5. 本サービスは、複数のお客様が投稿、修正、削除等の編集を行える機能を含む場合があります。この場合、お客様はご自身の投稿コンテンツに対する他のお客様の編集を許諾するものとします。\n9.6. お客様は、投稿コンテンツに対して有する権利を従前どおり保持し、当社がかかる権利を取得することはありません。ただし、投稿コンテンツのうち、友だち関係にない他のお客様一般にも公開されたものに限り、お客様は、当社に対し、これをサービスやプロモーションに利用する権利（当社が必要かつ適正とみなす範囲で省略等の変更を加える権利を含みます。また、かかる利用権を当社と提携する第三者に再許諾する権利を含みます。）を、無償で、無期限に、地域の限定なく許諾したこととなります。\n9.7. 当社は、法令または本規約の遵守状況などを確認する必要がある場合、投稿コンテンツの内容を確認することができます。ただし、当社はそのような確認を行なう義務を負うものではありません。\n9.8. 当社は、お客様が投稿コンテンツに関し法令もしくは本規約に違反し、または違反するおそれのあると認めた場合、その他業務上の必要がある場合、あらかじめお客様に通知することなく、投稿コンテンツを削除するなどの方法により、本サービスでの投稿コンテンツの利用を制限できます。\n"
    }
}

