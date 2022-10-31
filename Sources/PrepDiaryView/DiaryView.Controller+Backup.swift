//import SwiftUI
//import SwiftHaptics
//
//extension DiaryView.Controller {
//
//    //MARK: - Backup
//    
//    @objc func didZipBackupFiles(notification: Notification) {
//        guard let userInfo = notification.userInfo,
//              let url = userInfo[Notification.Keys.url] as? URL else {
//            return
//        }
//        archiveUrl = url
//
//        showingBackupFilePicker = true
//    }
//    
//    //MARK: - Restore
//    
//    @objc func didPickRestoreFile(notification: Notification) {
//        guard let url = notification.userInfo?[Notification.Keys.url] as? URL else {
//            return
//        }
//
//        isRestoring = true
//        restoreFilePickDate = Date()
//        withAnimation(.interactiveSpring()) {
//            showingRestoreOverlay = true
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            Store.importBackup(from: url)
//            
//            self.pagerController.refreshAfterBackupRestoration()
//        }
//    }
//
//    @objc func didRestoreBackupFile(notification: Notification) {
//        let minimumTime = 1.5
//        let enoughTimePassed = Date().timeIntervalSince(restoreFilePickDate) > minimumTime
//        let deadline = DispatchTime.now() + (enoughTimePassed ? minimumTime : 2.0)
//        DispatchQueue.main.asyncAfter(deadline: deadline) {
//            Haptics.feedback(style: .rigid)
//            withAnimation(.interactiveSpring()) {
//                self.showingRestoreOverlay = false
//                isRestoring = false
//            }
//        }
//    }
//}
