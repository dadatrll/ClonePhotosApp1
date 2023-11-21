//
//  ClonePhotosAppApp.swift
//  ClonePhotosApp
//
//  Created by Daniela Turiello on 20/11/23.
//

import SwiftUI
import PhotosUI

struct ImageClassificationView: View {
    
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    
    @ObservedObject var classification = ImageClassification()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
         Spacer()
            ZStack(alignment: avatarImage != nil ? .bottom : .center) {
                
                if let avatarImage {
                    avatarImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .ignoresSafeArea()
                        .cornerRadius(20)
                        .padding()
                    
                }
            }
              Spacer()
                HStack() {
                    
                    VStack() {
                    Text(classification.classificationLabel)    .padding()
                       
                        .foregroundColor(.black)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white.opacity(0.8))
                        )
                    
                        PhotosPicker(selection: $avatarItem, matching: .images, preferredItemEncoding: .automatic) {
                            Image(systemName: "photo.circle.fill")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.black, .gray)
                                .font(.system(size: 80))
                                .shadow(radius: 4.0)
                                .padding(5)
                        }
                    }
                
                }
            
            
                .navigationTitle("Camera")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "x.circle").padding(.top)
                        }
                    }
                }
            }
          
        
        .onDisappear {
                classification.classificationLabel = "Add a Photo."
            }
            .onChange(of: avatarItem) { oldValue, newValue in
                Task {
                    if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            withAnimation {
                                avatarImage = Image(uiImage: uiImage)
                            }
                            classification.updateClassifications(for: uiImage)
                            return
                        }
                    }
                    print("Failed")
                }
            }
  
    }
}



#Preview {
    ImageClassificationView()
}
