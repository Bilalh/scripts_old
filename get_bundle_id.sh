runcocoa <<EOF

NSString *vlcFilePath = @"$1";

NSBundle *bundle = [NSBundle bundleWithPath:vlcFilePath];
NSLog (@"%@", [bundle bundleIdentifier]);
EOF