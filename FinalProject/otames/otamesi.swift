// 全ての機能を使ったPhotosPickerの実装まとめ

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

//struct otamesi: View {
    /// フォトピッカー内で選択したアイテムが保持されるプロパティ
//    @State var selectedItems: [PhotosPickerItem] = []
    /// PhotosPickerItem -> UIImageに変換したアイテムを格納するプロパティ
//    @State var selectedImages: UIImage?
    
//    var body: some View {
//
//        VStack {
//            // 配列内にUIImageデータが存在すれば表示
//            if let selectedImages = selectedImages {
//                Image(uiImage: selectedImages)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 100,height: 100)
//                    .clipShape(Circle())
//                    .overlay(
//                        Circle().stroke(Color.white,lineWidth: 4))
//                    .shadow(radius: 10)
//            }
////            else{
////                Image(uiImage: selectedImages)
////                    .resizable()
////                    .frame(width: 100,height: 100)
////            }
//            // ピッカーを表示するビュー
//            PhotosPicker(
//                selection: $selectedItems,
//                maxSelectionCount: 1,
//                selectionBehavior: .default,
//                matching: .images
//            ) {
//                Text("画像を変更")
//            }
////            Button("画像をアップロードする", action: {
////                UploadImage()
////            })
////            Button("画像読み込み", action: {
////                fetchImage()
////            })
//        }
//        .onChange(of: selectedItems) { items in
//            // 複数選択されたアイテムをUIImageに変換してプロパティに格納していく
//            Task {
//                for item in items {
//                    guard let data = try await item.loadTransferable(type: Data.self) else { continue }
//                    guard let uiImage = UIImage(data: data) else { continue }
//                    selectedImages = uiImage
//                }
//            }
//        }
//        .background(Color.customlightGray)
//    }
//}

//func UploadImage(selectedImages: UIImage?, id:Int){
//    let storageref = Storage.storage().reference(forURL: "gs://sasami-cheese80.appspot.com").child("images").child("\(id).jpg")
//    let uploadMetadata = StorageMetadata.init()
//    uploadMetadata.contentType = "image/jpeg"
//    var image = selectedImages
//    let data = image!.jpegData(compressionQuality: 0.7)! as NSData
//        
//       storageref.putData(data as Data, metadata: uploadMetadata) { (data, error) in
//           if error != nil {
//               return
//           }
//       }
//}
//
//func fetchImage(id: Int, completion: @escaping (UIImage?) -> Void) {
//    let storageref = Storage.storage().reference(forURL: "gs://sasami-cheese80.appspot.com").child("images").child("\(id).jpg")
//    storageref.getData(maxSize: 4 * 1024 * 1024){ (data,error) in
//        if let error = error {
//                    print("Got an error fetching data: \(error.localizedDescription)")
//                    completion(nil)
//                    return
//                }
//                if let data = data {
//                    if let image = UIImage(data: data) {
//                        completion(image)
//                    } else {
//                        print("Could not convert data to UIImage.")
//                        completion(nil)
//                    }
//                } else {
//                    print("Data was nil.")
//                    completion(nil)
//                }
//    }
//}

