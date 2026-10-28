# CPRS release update — instructions for AI agents

This directory holds the CPRS GUI source (`CPRS-Chart/`), refreshed from each VA
FOIA source release (patch `OR*3.0*NNN`) with a few small local modifications.
This file describes how to bring in a new release, build it, and get it ready
for testing and deployment.

It lives here, and not inside `CPRS-Chart/`, because `CPRS-Chart/` is replaced
wholesale on every release.

The top-level `BUILD-Delphi.rst` (Delphi 2007 + CMake) is obsolete and does
not apply to current CPRS.

## Ground rules

- **Never `git commit` or `git push`.** Never write to remote systems
  (code.worldvista.org, Docker Hub, GitHub). The maintainer does those. You can
  prepare files, commands and a commit message for them.
- **Ask before deleting anything.** Move the old tree aside instead.
- **Edit Delphi files with an editor tool, not `sed`/`perl` one-liners.** Paths
  in `.dproj`/`.dpk` files are full of `\`, `$(...)` and quotes, and shell
  escaping has silently corrupted them before.
- **Keep CRLF line endings** on Delphi files (`.pas .dfm .dpk .dproj
  .groupproj .dpr .inc .bat`). LF files have corrupted projects in the IDE.
  Some VA units are Windows-1252, not UTF-8; preserve their encoding.

## Layout

- `CPRS-Chart/`: the VA source tree, which is the root of the source zip.
  - `CPRSChart.dproj` / `.dpr`: the CPRS application.
  - `packages/`: component packages (Broker, VA, OR, 508, CCOW, ...).
    - `packages/Project Groups/12/CPRS_Packages_12.groupproj`: the package
      build order.
  - `help/`: RoboHelp *source* only. The deployable `help\cprs.chm` is not
    in the zip; it comes from the previous deployment.
- Toolchain: whatever Delphi Community Edition is current. It installs under
  `C:\Program Files (x86)\Embarcadero\Studio\<NN.0>` (the folder number changes
  with each Delphi version). The build scripts below pick the newest install
  that has `bin\rsvars.bat`; set `BDS_DIR` to override.
- The `12` in `Packages/12` and the `*_D12`/`*_R12` package names is VA's
  naming for its newest package set, not the compiler you must use. Newer
  Delphi versions build them fine. If VA ships a newer package set, use that
  instead.
- Release source zips are published here:
  `https://foia-vista.worldvista.org/Patches by Year and Month Released/<YYYY>/<Month YYYY>/OR_30_<patch>_SRC_scrubbed.zip`

## Procedure

### 1. Baseline

1. Build the current committed source first (step 6) so you know the toolchain
   works before changing anything.
2. Save any uncommitted edits: `git diff > <scratch>/mods.patch`.

### 2. Download and diff

1. Download the zip into a new, empty scratch directory and unzip it there.
2. Export the committed tree:
   `git archive HEAD "Packages/Order Entry Results Reporting/CPRS/CPRS-Chart" | tar -x -C <scratch>/old`.
3. Compare: `diff -rq --strip-trailing-cr <old> <new>`.
4. Report a short summary to the maintainer, calling out:
   - Anything under `packages/Broker/Source` (login, SSOi/PIV, `Trpcb.pas`).
   - Changes to `ORNet.pas`.
   - Project and package (`.dproj`/`.dpk`) changes.
5. Expected noise, which needs no action:
   - Files only in the old tree: `*.res`, `*.dres`, `CPRSChart.exe`, and
     `CPRSChartResource.rc` (generated from the `.dproj` `RcItem`s).
   - `HTML Dialogs/JavaScriptBundle/dist/bundle.js`: unpacked from
     `bundle.zip` at runtime.
   - `Deployment Version`/Android blocks in `.dproj` files: IDE churn.
6. Check that `dist/bundle.zip` is present. In one release it was missing and
   had to be regenerated with `npm run buildP` in `JavaScriptBundle/`.

### 3. Replace the source

Move the old `CPRS-Chart/` to scratch, then copy the new tree into its place.
Do not delete the old tree.

### 4. Normalize line endings

VA zips ship around 1,000 LF-only Delphi files. Convert every text file of the
types above to CRLF. Check each with `file`, and skip binary `.dfm`/`.res`
files. Git's `text=auto` normalizes on staging, so this adds no real diff.
Afterwards, `git diff --ignore-cr-at-eol --stat` shows the true change size.

### 5. Re-apply local modifications

Re-apply every item below that VA's source still lacks. Check each one first,
because VA occasionally adopts a fix.

**Build fixes:**

| Where | Change | Why |
|---|---|---|
| `packages/Broker/Source/XlfSid.pas` | `external advapi32 name 'ConvertSidToStringSidW'` (VA ships `...A`) | SID/Unicode fix, see http://smh101.com/articles/p6/cprs-unicode.html |
| `packages/Broker/Packages/12/XWB_R12.dpk` and `.dproj` | add `wcrypt2 in '..\..\Source\wcrypt2.pas'` / `<DCCReference Include="..\..\Source\wcrypt2.pas"/>` after `XWBLoginForm` | needed by `XWBSSOi` |
| `packages/VA/Packages/12/VAShared_R12.dpk` and `.dproj` | add `VAShared.ScreenHelper` after `VAShared.CursorHelper` | CCOW package fails with F2613 without it |
| `CPRSChart.dproj` | default `<Config ...>Release</Config>`; add `$(Packages)\CCOW\Source;` before `$(DCC_UnitSearchPath)` in `DCC_UnitSearchPath` | Release build; CCOW units |
| all package `.dproj` (`packages/*/Packages/12/*.dproj`, `packages/CCOW/Packages/CCOW.dproj`) | default `<Config ...>Release</Config>` (VA ships `Debug`) | IDE builds should be Release. Release is `Cfg_2` in IDEUtils and CCOW, `Cfg_1` elsewhere |
| `InfoPanel/uPtInfoCore.pas`, `uPtInfoData.pas`, `SpecialAuthority/uSpecialAuthority*.pas` | `TJsonTypedListConverter<` → `TJsonListConverter<` | Delphi 13 and later no longer have the old class. The new one is a drop-in replacement (it creates the concrete list via the contract's `DefaultCreator`) |

**Features (tagged `// OSEHRA/SMH` in the code):**

1. **Access/verify codes on the command line.** In `packages/OR/Source/ORNet.pas`:
   - `ConnectToServer` parses `AC=` and `VC=`. It keeps everything after the
     first `=`, so codes may contain `=`.
   - It passes them to `SetBrokerServer(..., AC, VC)`, which sets
     `RPCBrokerV.AccessVerifyCodes := AC + ';' + VC`.
   - The broker then signs on silently. If the codes fail, the normal sign-on
     screen appears.
   - The original version was commit `1f01619b`, in `CPRS-Lib/ORNet.pas`.

   Example: `CPRSChart.exe s=<host> p=<port> ccow=disable ac=PRO1234 vc=PRO1234!!`

2. **No PIV/2FA screens outside the VA.** In `packages/Broker/Source/Trpcb.pas`:
   - A new function, `IAMServerConfigured`, returns true only if a value is
     set under `HKLM\Software\Vista\Common\IAM` or `...\IAM_AD`. VA
     workstations have these keys.
   - `AuthenticateUser`'s first SSOi block is gated on it.
   - The p74 retry (`SSOiRetry`) can only start from that block, so it is
     skipped too.
   - Without the keys, login goes straight to the access/verify screen.
   - The compiled-in `IAM_Server_URL` is a scrubbed placeholder that can never
     work, so it is ignored.

If neither `ORNet.pas` nor `Trpcb.pas` changed upstream, the saved patch from
step 1 usually applies cleanly: `git apply --ignore-whitespace`. Re-normalize
CRLF on the touched files afterwards.

### 6. Build (command line)

MSBuild quirks this has to work around:

- **Build events.** Package pre/post-build `.bat` events run with
  `cwd=$(OutDir)`, so each package's folder must be on `PATH`.
- **Post-build copies.** The copies to `Bpl\Resource` don't run under MSBuild.
- **`wcrypt2` (error E2203).** `CPRSChart` enables writeable constants (`$J+`),
  so `wcrypt2` (`{$WEAKPACKAGEUNIT}`) fails E2203 if compiled from source.
  Link the package-built DCUs instead:
  - put every `packages\*\dcu` folder first in the search path;
  - leave out `packages\Broker\Source`;
  - add a folder holding copies of the `packages\Broker\Source\*.dfm` files.

  The maintainer does the equivalent in the IDE by adding the DCU folders to
  the search path.
- **Make, not Build.** Use `/t:Make` for CPRS. `/t:Build` forces recompiling
  `wcrypt2` from source.
- **Escaping.** Escape `;` as `%%3B` inside `/p:DCC_UnitSearchPath=` in a
  `.bat` file.

Packages (`build_pkgs.bat <CPRS-Chart\packages>`):

```bat
@echo off
rem Use BDS_DIR if set; otherwise pick the newest installed RAD Studio/Delphi that has rsvars.bat.
if not defined BDS_DIR for /f "delims=" %%V in ('dir /b /ad "%ProgramFiles(x86)%\Embarcadero\Studio" ^| sort') do if exist "%ProgramFiles(x86)%\Embarcadero\Studio\%%V\bin\rsvars.bat" set "BDS_DIR=%ProgramFiles(x86)%\Embarcadero\Studio\%%V"
if not defined BDS_DIR ( echo No Delphi installation found & exit /b 1 )
call "%BDS_DIR%\bin\rsvars.bat"
set "PK=%~1"
set "BASEPATH=%PATH%"
for %%P in ("Broker\Packages\12\XWB_R12" "VA\Packages\12\VAShared_R12" "PKI\Packages\12\PKI_R12" "ResponsiveGUI\Packages\12\ResponsiveGUI_R12" "IDEUtils\Packages\12\IDEUtils_D12" "Broker\Packages\12\XWB_D12" "Borland\Packages\12\Borland_D12" "508\Packages\12\VA508Access_D12" "OR\Packages\12\ORCtrls_D12" "CopyPaste\Packages\12\CopyPaste_D12" "ExceptionLogger\Packages\12\ExceptionLogger_R12" "CCOW\Packages\CCOW") do (
  call :build "%%~P" || exit /b 1
)
echo ===== ALL PACKAGES OK
exit /b 0

:build
echo ===== %~n1
cd /d "%PK%\%~1\.."
set "PATH=%CD%;%BASEPATH%"
msbuild "%~n1.dproj" /t:Build /p:Config=Release /p:Platform=Win32 /v:minimal /nologo
if errorlevel 1 ( echo ===== FAILED %~n1 & exit /b 1 )
exit /b 0
```

The list follows the order in `CPRS_Packages_12.groupproj`. Update it if VA
adds or renames packages.

CPRS (`build_cprs.bat <CPRS-Chart>`). Replace `<BROKERDFM>` with the folder of
copied Broker `.dfm` files:

```bat
@echo off
rem Same Delphi detection as build_pkgs.bat.
if not defined BDS_DIR for /f "delims=" %%V in ('dir /b /ad "%ProgramFiles(x86)%\Embarcadero\Studio" ^| sort') do if exist "%ProgramFiles(x86)%\Embarcadero\Studio\%%V\bin\rsvars.bat" set "BDS_DIR=%ProgramFiles(x86)%\Embarcadero\Studio\%%V"
if not defined BDS_DIR ( echo No Delphi installation found & exit /b 1 )
call "%BDS_DIR%\bin\rsvars.bat"
cd /d "%~1"
set "PATH=%CD%;%PATH%"
msbuild CPRSChart.dproj /t:Make /p:Config=Release /p:Platform=Win32 "/p:Packages=%CD%\packages" "/p:DCC_UnitSearchPath=packages\Broker\dcu%%3B<BROKERDFM>%%3Bpackages\VA\dcu%%3Bpackages\PKI\dcu%%3Bpackages\ResponsiveGUI\dcu%%3Bpackages\508\dcu%%3Bpackages\Borland\dcu%%3Bpackages\OR\dcu%%3Bpackages\CopyPaste\dcu%%3Bpackages\ExceptionLogger\dcu%%3Bpackages\508\Source%%3Bpackages\Borland\Source%%3Bpackages\CopyPaste\Source%%3Bpackages\ExceptionLogger\Source%%3Bpackages\FilemanComponents\Source%%3Bpackages\OR\Source%%3Bpackages\PKI\Source%%3Bpackages\VA\Source%%3Bpackages\ResponsiveGUI\Source%%3Bpackages\CCOW\Source" /v:minimal /nologo
```

The build fails with F2039 if `CPRSChart.exe` is running; ask the maintainer
to close it.

### 7. Verify

- **Version.** `(Get-Item CPRSChart.exe).VersionInfo.FileVersion` matches the
  new release, e.g. `1.33.214.5` for `OR*3.0*639`.
- **Release mode.** Rebuild with `/v:normal` and check the `dcc32.exe` command
  lines: every package and CPRS should show `-DRELEASE`, and packages
  `-$D0 -$L- -$Y-`. CPRS's Release config intentionally keeps DCU debug info
  and a detailed `.map` (`-GD`), because the ExceptionLogger reads
  `CPRSChart.map` for stack traces.
- **Local modifications.** `CPRSChart.map` contains `Trpcb.IAMServerConfigured`.

### 8. Hand off to the maintainer

These steps are done by the maintainer, not the agent:

1. **Test against VistA**, using the `ac=`/`vc=` command line. The test system
   is reached over VPN, so if the host is unreachable, check the VPN first.
2. **Deploy to code.worldvista.org.**
   - Create `/var/www/html/code/files/clients/OSEHRA_VistA/CPRS/<1_33_x_y>/`.
   - Copy in `CPRSChart.exe`, `CPRSChart.map`, `borlndmm.dll` and
     `WebView2Loader.dll`.
   - From the previous version's folder, copy forward the `help` folder (with
     `cprs.chm`), the Vitals DLLs (e.g. `GMV_VitalsViewEnter.dll`) and the MHA
     DLLs. `RoboEx32.dll` is not used by CPRS.
   - Re-point the `current_version` symlink.
3. **Update** the Docker Hub `worldvista/vehu` README with the new version.
4. **Commit.** Use the title format of previous releases:
   `CPRS <short name> Source Code with small mod`. The body lists the version
   and patch, the mods to code, the binaries URL, and notes on VA source fixes
   needed to compile (see `git log -- "Packages/Order Entry Results Reporting/CPRS"`).
   - `CPRSChart.exe` is tracked in git (added in `b6303218`), so the rebuilt
     exe shows as modified. Ask the maintainer whether to include it.
   - Do not commit test DLLs copied into the tree (e.g. Vitals).
