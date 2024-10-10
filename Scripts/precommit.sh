# اسم السكربت: precommit.ps1

# -------------------------------
# 1️⃣ Format الكود
Write-Host "🔹 Formatting Dart code..."
dart format .

# -------------------------------
# 2️⃣ تطبيق fixes
Write-Host "🔹 Applying Dart fixes..."
dart fix --apply

# -------------------------------
# 3️⃣ إزالة جميع print statements
Write-Host "🔹 Removing print statements..."
Get-ChildItem -Path . -Recurse -Include *.dart | ForEach-Object {
    (Get-Content $_.FullName) -replace '^\s*print\(.*\);\s*$', '' | Set-Content $_.FullName
}

# -------------------------------
# 4️⃣ إضافة التغييرات إلى Git
Write-Host "🔹 Adding changes to Git..."
git add .

Write-Host "✅ All done! Ready for commit."
