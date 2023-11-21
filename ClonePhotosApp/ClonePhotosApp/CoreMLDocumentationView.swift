//
//  ClonePhotosAppApp.swift
//  ClonePhotosApp
//
//  Created by Daniela Turiello on 20/11/23.
//

import SwiftUI

struct CoreMLDocumentationView: View {
    @State var isModalCOMLShowed = false
    @State var isModalVideoShowed = false
    
    var body: some View {
        NavigationStack {
            
            Form {
                
                Section {
                    HStack()
                    {
                        Spacer()
                        Button(action: {
                            isModalVideoShowed = true
                        }){
                            Text("live camera")
                                .fontWeight(.bold)
                                .foregroundStyle(Color("TextColor"))
                            Image(systemName: "camera.viewfinder")
                                .font(Font.custom("SF Pro", size: 25))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 90)
                                .padding(.vertical, 30)
                                .background(.orange)
                                .cornerRadius(13.0)
                            
                        }.padding(.vertical, 20)
                        .sheet(isPresented: $isModalVideoShowed) {
                           VideoView()
                                .padding(.vertical, 20)
                        }
                        Spacer()
                        
                    }
                } header: {
                    Text("Recognize objects by using live camera")
                        .font(Font.custom("SF Pro", size: 13))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
            
                }
                Section {
                    HStack() {
                        Spacer()
                        Button(action: {
                            isModalCOMLShowed = true
                        }){
                            Text("photos")
                                .fontWeight(.bold)
                                .foregroundStyle(Color("TextColor"))
                            Image(systemName: "plus.viewfinder")
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 90)
                                .padding(.vertical, 30)
                                .font(Font.custom("SF Pro", size: 25))
                                .background(.orange)
                                .cornerRadius(13.0)
                        }.padding().sheet(isPresented: $isModalCOMLShowed) {
                            ImageClassificationView()
                        }
                        Spacer()
                    }
                } header: {
                    Text("Recognize objects in images by Photos")
                        .font(Font.custom("SF Pro", size: 13))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                             
                }
            }
            
            .navigationTitle("Machine Learning")
        }
    }
}

#Preview {
    CoreMLDocumentationView().preferredColorScheme(.dark)
}
