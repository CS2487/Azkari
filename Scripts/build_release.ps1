# =========================================
# Build Flutter AppBundle Release Script
# =========================================

Write-Host "🚀 Starting Flutter Release Build Script..."

# -------------------------------
# 1️⃣ تنظيف المشروع
Write-Host "🔹 Cleaning project..."
flutter clean

# -------------------------------
# 2️⃣ جلب الحزم
Write-Host "🔹 Getting dependencies..."
flutter pub get

# -------------------------------
# 3️⃣ Format الكود
Write-Host "🔹 Formatting Dart code..."
dart format .

# -------------------------------
# 4️⃣ تطبيق fixes
Write-Host "🔹 Applying Dart fixes..."
dart fix --apply

# -------------------------------
# 5️⃣ إزالة جميع print statements
Write-Host "🔹 Removing print statements..."
Get-ChildItem -Path . -Recurse -Include *.dart | ForEach-Object {
    (Get-Content $_.FullName) -replace '^\s*print\(.*\);\s*$', '' | Set-Content $_.FullName
}

# -------------------------------
# 6️⃣ بناء App Bundle مضغوط وجاهز للرفع
Write-Host "🔹 Building App Bundle (.aab) for Play Store..."
flutter build appbundle --release

# -------------------------------
Write-Host "✅ All done! AppBundle ready for release."
Write-Host "📂 Path: build/app/outputs/bundle/release/app-release.aab"



