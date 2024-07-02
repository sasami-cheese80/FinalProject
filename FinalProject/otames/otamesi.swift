// 全ての機能を使ったPhotosPickerの実装まとめ

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

struct otamesi: View {
    /// フォトピッカー内で選択したアイテムが保持されるプロパティ
    @State var selectedItems: [PhotosPickerItem] = []
    /// PhotosPickerItem -> UIImageに変換したアイテムを格納するプロパティ
    @State var selectedImages: UIImage? = UIImage(named: "unknown4.png")

    var body: some View {

        VStack {
            // 配列内にUIImageデータが存在すれば表示
            if let selectedImages = selectedImages {
                Image(uiImage: selectedImages)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100,height: 100)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white,lineWidth: 4))
                    .shadow(radius: 10)
            }
//            else{
//                Image(uiImage: selectedImages)
//                    .resizable()
//                    .frame(width: 100,height: 100)
//            }
            // ピッカーを表示するビュー
            PhotosPicker(
                selection: $selectedItems,
                maxSelectionCount: 1,
                selectionBehavior: .default,
                matching: .images
            ) {
                Text("画像を変更")
            }
            Button("画像をアップロードする", action: {
                UploadImage()
            })
            Button("画像読み込み", action: {
                fetchImage()
            })
        }
        .onChange(of: selectedItems) { items in

            // 複数選択されたアイテムをUIImageに変換してプロパティに格納していく
            Task {
                for item in items {
                    guard let data = try await item.loadTransferable(type: Data.self) else { continue }
                    guard let uiImage = UIImage(data: data) else { continue }
                    selectedImages = uiImage
                }
            }
        }
    }
            
    func UploadImage(){
        let randomID = 4
        let storageref = Storage.storage().reference(forURL: "gs://sasami-cheese80.appspot.com").child("images").child("\(randomID).jpg")
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        let image = self.selectedImages
        let data = image!.jpegData(compressionQuality: 0.7)! as NSData
            
           storageref.putData(data as Data, metadata: uploadMetadata) { (data, error) in
               if error != nil {
                   return
               }
           }
    }
    func fetchImage(){
        let randomID = 1
        let storageref = Storage.storage().reference(forURL: "gs://sasami-cheese80.appspot.com").child("images").child("\(randomID).jpg")
        storageref.getData(maxSize: 4 * 1024 * 1024){ (data,error) in
            if let error = error{
                print("Got an error fetching data: \(error.localizedDescription)")
                return
            }
            if let data = data{
                self.selectedImages = UIImage(data:data)
            }
        }
    }
}


//import SwiftUI
//import FirebaseStorage
//import FirebaseFirestore
//import UIKit
//
//class ImagePickerViewModel: ObservableObject {
//    @Published var image: UIImage?
//    @Published var imagePath: String = ""
//    
//    func uploadImage() async {
//        guard let image = image else { return }
//        guard let data = image.jpegData(compressionQuality: 0.5) ?? image.pngData() else { return }
//        
//        let storage = Storage.storage()
//        let storageRef = storage.reference()
//        let imageRef = storageRef.child("image/\(UUID().uuidString)")
//        
//        do {
//            let _ = try await imageRef.putData(data, metadata: nil)
//            self.imagePath = imageRef.fullPath
//            await saveImagePathToFirestore()
//        } catch {
//            print("Error uploading image: \(error)")
//        }
//    }
//    
//    func saveImagePathToFirestore() async {
//        let db = Firestore.firestore()
//        do {
//            try await db.collection("photos").document().setData(["path": self.imagePath])
//        } catch {
//            print("Error saving image path to Firestore: \(error)")
//        }
//    }
//}
//
//struct otamesi: View {
//    @StateObject private var viewModel = ImagePickerViewModel()
//    @State private var isImagePickerPresented = false
//    
//    var body: some View {
//        VStack {
//            Rectangle()
//                .fill(Color.gray)
//                .frame(width: 200, height: 200)
//                .overlay(
//                    Image(uiImage: viewModel.image ?? UIImage())
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                )
//                .onTapGesture {
//                    isImagePickerPresented = true
//                }
//            
//            Button("Save Image") {
//                Task {
//                    await viewModel.uploadImage()
//                }
//            }
//            .padding(.top, 20)
//        }
//        .sheet(isPresented: $isImagePickerPresented) {
//            ImagePicker(image: $viewModel.image, isPresented: $isImagePickerPresented)
//        }
//    }
//}
//
//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var image: UIImage?
//    @Binding var isPresented: Bool
//    
//    func makeUIViewController(context: Context) -> some UIViewController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        return picker
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//        let parent: ImagePicker
//        
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//        
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let image = info[.originalImage] as? UIImage {
//                parent.image = image
//            }
//            parent.isPresented = false
//        }
//        
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            parent.isPresented = false
//        }
//    }
//}
