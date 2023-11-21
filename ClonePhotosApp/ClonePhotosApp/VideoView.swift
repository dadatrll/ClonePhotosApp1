//
//  ClonePhotosAppApp.swift
//  ClonePhotosApp
//
//  Created by Daniela Turiello on 20/11/23.
//

import SwiftUI

struct VideoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            VStack() {
                if Platform.isSimulator {
                  
                    Text("Oops! You are using the Simulator 👀. \nRun the App on iPhone to use the \nlive Camera.").multilineTextAlignment(.center).padding()
                }else{
                    SwiftUIAVCaptureVideoPreviewView()
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
    }
}

#Preview {
    VideoView().preferredColorScheme(.dark)
}

// This block is used in order to detect if the app is running on a simulator or not. In this case, the detection will prevent a crash of the app during the preview of the live camera.

struct Platform {

    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }

}
