program Virmariza;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {MainForm},
  Articulos in 'Articulos.pas' {fArticulos},
  Linea in 'Linea.pas' {Lineas},
  Androidapi.JNI.Toasts in 'Librerias_Android\Androidapi.JNI.Toasts.pas',
  AndroidApi.ProgressDialog in 'Librerias_Android\AndroidApi.ProgressDialog.pas',
  FGX.ActionSheet.Android in 'Librerias_Android\FGX.ActionSheet.Android.pas',
  FGX.ActionSheet in 'Librerias_Android\FGX.ActionSheet.pas',
  FGX.ActionSheet.Types in 'Librerias_Android\FGX.ActionSheet.Types.pas',
  FGX.Animations in 'Librerias_Android\FGX.Animations.pas',
  FGX.ApplicationEvents in 'Librerias_Android\FGX.ApplicationEvents.pas',
  FGX.Asserts in 'Librerias_Android\FGX.Asserts.pas',
  FGX.BitBtn in 'Librerias_Android\FGX.BitBtn.pas',
  FGX.Colors.Presets in 'Librerias_Android\FGX.Colors.Presets.pas',
  FGX.ColorsPanel in 'Librerias_Android\FGX.ColorsPanel.pas',
  FGX.Consts in 'Librerias_Android\FGX.Consts.pas',
  FGX.FlipView.Effect in 'Librerias_Android\FGX.FlipView.Effect.pas',
  FGX.FlipView in 'Librerias_Android\FGX.FlipView.pas',
  FGX.FlipView.Presentation in 'Librerias_Android\FGX.FlipView.Presentation.pas',
  FGX.FlipView.Sliding in 'Librerias_Android\FGX.FlipView.Sliding.pas',
  FGX.FlipView.Types in 'Librerias_Android\FGX.FlipView.Types.pas',
  FGX.GradientEdit in 'Librerias_Android\FGX.GradientEdit.pas',
  FGX.Graphics in 'Librerias_Android\FGX.Graphics.pas',
  FGX.Helpers.Android in 'Librerias_Android\FGX.Helpers.Android.pas',
  FGX.Helpers in 'Librerias_Android\FGX.Helpers.pas',
  FGX.Images.Types in 'Librerias_Android\FGX.Images.Types.pas',
  FGX.Items in 'Librerias_Android\FGX.Items.pas',
  FGX.LinkedLabel.Android in 'Librerias_Android\FGX.LinkedLabel.Android.pas',
  FGX.LinkedLabel in 'Librerias_Android\FGX.LinkedLabel.pas',
  FGX.ProgressDialog.Android in 'Librerias_Android\FGX.ProgressDialog.Android.pas',
  FGX.ProgressDialog in 'Librerias_Android\FGX.ProgressDialog.pas',
  FGX.ProgressDialog.Types in 'Librerias_Android\FGX.ProgressDialog.Types.pas',
  FGX.Toasts.Android in 'Librerias_Android\FGX.Toasts.Android.pas',
  FGX.Toasts in 'Librerias_Android\FGX.Toasts.pas',
  FGX.Toolbar in 'Librerias_Android\FGX.Toolbar.pas',
  FGX.Types in 'Librerias_Android\FGX.Types.pas',
  FGX.Types.StateValue in 'Librerias_Android\FGX.Types.StateValue.pas',
  FGX.VirtualKeyboard in 'Librerias_Android\FGX.VirtualKeyboard.pas',
  FGX.VirtualKeyboard.Types in 'Librerias_Android\FGX.VirtualKeyboard.Types.pas',
  Presentacion in 'Presentacion.pas' {fPresentacion};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TfArticulos, fArticulos);
  Application.CreateForm(TLineas, Lineas);
  Application.CreateForm(TfPresentacion, fPresentacion);
  Application.Run;
end.
