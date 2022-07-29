//
//  LoadingView.swift
//  MovieChecker
//
//  Created by Piotr Woźniak on 11/07/2022.
//

import SwiftUI

struct LoadingView: View {
    let isLoading: Bool
    let error: NSError?
    let retryAction: (() -> ())?

    var body: some View {
        Group {
            if isLoading {
                HStack {
                    Spacer()
//                    ActivityIndicatorView()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                        .scaleEffect(2)
                    Spacer()
                }
            } else if error != nil {
                HStack {
                    Spacer()
                    VStack(spacing: 4) {
                        Text(error!.localizedDescription)
                            .font(.headline)
                        if retryAction != nil {
                            Button(action: retryAction!) {
                                Text("Retry")
                            }
                            .foregroundColor(Color(UIColor.systemBlue))
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(isLoading: true, error: nil, retryAction: nil)
    }
}
