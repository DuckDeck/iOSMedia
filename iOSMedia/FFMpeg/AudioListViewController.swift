
//
//  RecordListViewController.swift
//  iOSDemo
//
//  Created by Stan Hu on 21/04/2018.
//  Copyright © 2018 Stan Hu. All rights reserved.
//

import UIKit
import AVFoundation
import GrandTime
import SwiftUI
class AudioListViewController: UIViewController {

    let tb = UITableView()
    var arrFiles:[URL]?
    var player: AVAudioPlayer!
    var timer:GrandTimer!

    var currentSelectIndex:IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        timer = GrandTimer.scheduleTimerWithTimeSpan(TimeSpan.fromTicks(500), target: self, sel: #selector(tick), userInfo: nil, repeats: true, dispatchQueue: DispatchQueue.main)
        tb.dataSource = self
        tb.delegate = self
        tb.tableFooterView = UIView()
        tb.estimatedRowHeight = 60
        tb.separatorStyle = .none
        tb.register(AudioFileCell.self, forCellReuseIdentifier: "audio")
        view.addSubview(tb)
        tb.snp.makeConstraints { (m) in
            m.left.right.equalTo(0)
            m.top.equalTo(0)
            m.bottom.equalTo(-80)
        }
        let v = UITableView.createEmptyView(size: CGSize(width: ScreenWidth, height: 50), text: "目前没有音频文件", font: UIFont.systemFont(ofSize: 20), color: UIColor.brown)
        tb.setEmptyView(view: v, offset: 300)
        listRecordings()
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try? AVAudioSession.sharedInstance().setActive(true)
        
       // navigationItem.rightBarButtonItem = UIBarButtonItem(title: "去录音", style: .plain, target: self, action: #selector(gotoRecord))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        parent?.navigationItem.title = "录音列表"
        let btnDelete = UIBarButtonItem(title: "删除录音", style: .plain, target: self, action: #selector(deleteAllRecord))
        let btnRecord = UIBarButtonItem(title: "去录音", style: .plain, target: self, action: #selector(gotoRecord))
        navigationController?.navigationBar.topItem?.rightBarButtonItems = [btnRecord,btnDelete]

    }
    
    @objc func playRecord() {
        let indexPath = IndexPath(row: 0, section: 0)
        let url = arrFiles![indexPath.row]
        currentSelectIndex = indexPath
        timer.fire()
        play(url)
    }
    
    @objc func tick()  {
       let cell = tb.cellForRow(at: currentSelectIndex!) as! AudioFileCell
        let ratio = player.currentTime / Double(cell.totalTime)
     
     
    }
    

    @objc func gotoRecord(){
        let vc = AudioDecoderViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func listRecordings() {
        timer.invalidate()
        var documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsDirectory.appendPathComponent("Voice")
        let fileManager = FileManager.default
        do {
            let files = try fileManager.contentsOfDirectory(at: documentsDirectory,
                                                            includingPropertiesForKeys: nil,
                                                            options: .skipsHiddenFiles)
            arrFiles = files.filter({ (name: URL) -> Bool in
                return name.pathExtension == "m4a" || name.pathExtension == "mp3" || name.pathExtension == "caf"
                
            })
            tb.emptyReload()
          
        } catch {
            print("could not get contents of directory at \(documentsDirectory)")
            print(error.localizedDescription)
        }
    }
    
    
    func deleteAllAudio() {
        if let files = arrFiles{
            let fileManager = FileManager.default
            for i in 0 ..< files.count {
                print("removing \(files[i])")
                do {
                    try fileManager.removeItem(at: files[i])
                } catch {
                    print("could not remove \(files[i])")
                    print(error.localizedDescription)
                }
            }
            arrFiles?.removeAll()
            tb.emptyReload()
            GrandCue.toast("已经全部删除")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if player != nil && player.isPlaying{
            player.stop()
            timer.invalidate()
        }
    }
    
    func play(_ url: URL) {
        print("playing \(url)")
        
        do {

            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
            player.delegate = self
            GrandCue.toast("正在播放\(url.lastPathComponent)")
        } catch {
            self.player = nil
            print(error.localizedDescription)
            print("AVAudioPlayer init failed")
        }
        
    }
    
    @objc func deleteAllRecord() {
        UIAlertController.title(title: "删除所有声音文件", message: nil).action(title: "确定", handle: {[weak self](action:UIAlertAction) in
            self?.deleteAllAudio()
        }).action(title: "取消", handle: nil).show()
    }
    
    
    
    func deleteAudio(url:URL)   {
        
        UIAlertController.title(title: "删除该\(url.lastPathComponent)声音文件", message: nil).action(title: "确定", handle: {[weak self](action:UIAlertAction) in
            self?.deleteRecording(url)
        }).action(title: "取消", handle: nil).show()
        
        
    }
    
    func rename(url:URL) {
        let alert = UIAlertController(title: "Rename",
                                      message: "Rename Recording \(url.lastPathComponent)?",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            [unowned alert] _ in
            print("yes was tapped \(url)")
            if let textFields = alert.textFields {
                let tfa = textFields as [UITextField]
                let text = tfa[0].text
                let newUrl = URL(fileURLWithPath: text!)
                self.renameRecording(url, to: newUrl)
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: {_ in
            print("no was tapped")
        }))
        alert.addTextField(configurationHandler: {textfield in
            textfield.placeholder = "Enter a filename"
            textfield.text = "\(url.lastPathComponent)"
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func renameRecording(_ from: URL, to: URL) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let toURL = documentsDirectory.appendingPathComponent(to.lastPathComponent)
        
        print("renaming file \(from.absoluteString) to \(to) url \(toURL)")
        let fileManager = FileManager.default
        fileManager.delegate = self
        do {
            try FileManager.default.moveItem(at: from, to: toURL)
        } catch {
            print(error.localizedDescription)
            print("error renaming recording")
        }
        DispatchQueue.main.async {
            self.listRecordings()
            self.tb.emptyReload()
        }
    }
    func deleteRecording(_ url: URL) {
        
        print("removing file at \(url.absoluteString)")
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: url)
        } catch {
            print(error.localizedDescription)
            print("error deleting recording")
        }
        
        DispatchQueue.main.async {
            self.listRecordings()
            self.tb.emptyReload()
        }
    }
}

extension AudioListViewController:FileManagerDelegate{
    func fileManager(_ fileManager: FileManager, shouldMoveItemAt srcURL: URL, to dstURL: URL) -> Bool {
        
        print("should move \(srcURL) to \(dstURL)")
        return true
    }
}

extension AudioListViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFiles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "audio", for: indexPath) as! AudioFileCell
        cell.url = arrFiles![indexPath.row]
        cell.block = {[weak self](action:Int,url:URL) in
            if action == 1{
                self?.rename(url: url)
            }
            else if action == 0{
                self?.deleteAudio(url: url)
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = arrFiles![indexPath.row]
        currentSelectIndex = indexPath
        timer.fire()
        play(url)
    }
}

extension AudioListViewController:AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        timer.pause()
        let cell = tb.cellForRow(at: currentSelectIndex!) as! AudioFileCell
       
    }
}

class AudioFileCell: UITableViewCell {
    let lblName = UILabel()
    let lblPlayTime = UILabel()
    let lblAudioLength = UILabel()
    let btnRename = UIButton()
    let btnDelete = UIButton()
    let btnConvertMp3 = UIButton()
    var block:((_ action:Int,_ url:URL)->Void)?
    var totalTime = 0
    var url:URL?{
        didSet{
            guard let u = url else {
                return
            }
            lblName.text = u.lastPathComponent
            if u.lastPathComponent.hasSuffix("caf")
            {
                btnConvertMp3.isHidden = false
            }
            else{
                btnConvertMp3.isHidden = true
            }
            
            if let attr = try? FileManager.default.attributesOfItem(atPath: u.path){
                let size = attr[FileAttributeKey.size] as! Int
                print("\(size / 1000.0)k")
                let assert = AVURLAsset(url: u)
                guard let track = assert.tracks(withMediaType: .audio).first else{
                    return
                }
                totalTime = Int((track.timeRange.duration.seconds))
                lblAudioLength.text = totalTime.toTimeSpan()
            }
            lblPlayTime.text = "00:00:00"
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        lblName.setFont(font: 14).color(color: UIColor.darkGray).addTo(view: contentView).snp.makeConstraints { (m) in
            m.left.equalTo(15)
            m.top.equalTo(10)
        }
        
        
        lblPlayTime.setFont(font: 14).color(color: UIColor.gray).addTo(view: contentView).snp.makeConstraints { (m) in
            m.left.equalTo(lblName)
            m.top.equalTo(lblName.snp.bottom).offset(8)
            m.width.equalTo(65)
            m.bottom.equalTo(-15)
        }
        
        lblAudioLength.setFont(font: 12).color(color: UIColor.purple).addTo(view: contentView).snp.makeConstraints { (m) in
            m.right.equalTo(-15)
            m.top.equalTo(lblPlayTime)
            m.width.equalTo(60)
        }
        
        btnDelete.title(title: "删除").setFont(font: 13).color(color: UIColor.red).addTo(view: contentView).snp.makeConstraints { (m) in
            m.right.equalTo(-10)
            m.top.equalTo(lblName)
            m.height.equalTo(30)
        }
        btnDelete.addTarget(self, action: #selector(deleteAudio), for: .touchUpInside)
        
        btnRename.title(title: "重命名").setFont(font: 13).color(color: UIColor.red).addTo(view: contentView).snp.makeConstraints { (m) in
            m.right.equalTo(btnDelete.snp.left).offset(-10)
           m.top.equalTo(lblName)
            m.height.equalTo(30)
        }
        btnRename.addTarget(self, action: #selector(rename), for: .touchUpInside)
        btnConvertMp3.isHidden = true
        btnConvertMp3.title(title: "转Mp3").setFont(font: 13).color(color: UIColor.red).addTo(view: contentView).snp.makeConstraints { (m) in
            m.right.equalTo(btnRename.snp.left).offset(-10)
            m.top.equalTo(lblName)
            m.height.equalTo(30)
        }
        btnConvertMp3.addTarget(self, action: #selector(convertMp3), for: .touchUpInside)
        
    }
    
    @objc func rename() {
        block?(1,url!)
    }
    
    @objc func deleteAudio() {
        block?(0,url!)
    }
    
    @objc func convertMp3() {
        block?(2,url!)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
struct AudioListDemo:UIViewControllerRepresentable {

    
    func updateUIViewController(_ uiViewController: AudioListViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = AudioListViewController
    
    
    func makeUIViewController(context: Context) -> AudioListViewController {
        return AudioListViewController()
    }
    
}
