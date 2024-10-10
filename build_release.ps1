# Build Flutter AppBundle Release Script

Write-Host "Starting Flutter Release Build Script..."

# 1- تنظيف المشروع
Write-Host "Cleaning project..."
flutter clean

# 2- جلب الحزم
Write-Host "Getting dependencies..."
flutter pub get

# 3- ترتيب الكود
Write-Host "Formatting Dart code..."
dart format .

# 4- تطبيق إصلاحات Dart
Write-Host "Applying Dart fixes..."
dart fix --apply

# 5- إزالة جميع print statements
Write-Host "Removing print statements..."
Get-ChildItem -Path . -Recurse -Include *.dart | ForEach-Object {
    (Get-Content $_.FullName) -replace '^\s*print\(.*\);\s*$', '' | Set-Content $_.FullName
}

# 6- بناء App Bundle
Write-Host "Building App Bundle (.aab) for Play Store..."
flutter build appbundle --release

# النهاية
Write-Host "All done! AppBundle ready for release."
Write-Host "Path: build/app/outputs/bundle/release/app-release.aab"
