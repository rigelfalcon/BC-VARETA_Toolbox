classdef freqresol_maxfreq_samplfreq_guide < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        PropertiesPanel                matlab.ui.container.Panel
        SamplingfrequencySpinnerLabel  matlab.ui.control.Label
        FrequencyresolutionSpinnerLabel  matlab.ui.control.Label
        FrequencyresolutionSpinner     matlab.ui.control.Spinner
        SamplingfrequencySpinner       matlab.ui.control.Spinner
        MaxfrequencySpinnerLabel       matlab.ui.control.Label
        MaxfrequencySpinner            matlab.ui.control.Spinner
        CancelButton                   matlab.ui.control.Button
        OkButton                       matlab.ui.control.Button
    end

    
    properties (Access = private)
        Property % Description
    end
    
    properties (Access = public)
        frequency_resolution % Resolution frequency
        sampling_frequency % Samplin frequency
        max_frequency % Max frequency
        
    end
    

    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            
        end

        % Button pushed function: CancelButton
        function CancelButtonPushed(app, event)
            
            uiresume(app.UIFigure);
            close();
        end

        % Button pushed function: OkButton
        function OkButtonPushed(app, event)
            app.frequency_resolution = app.FrequencyresolutionSpinner.Value;
            app.sampling_frequency = app.SamplingfrequencySpinner.Value;
            app.max_frequency = app.MaxfrequencySpinner.Value;
            uiresume(app.UIFigure);
            
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 318 284];
            app.UIFigure.Name = 'UI Figure';

            % Create PropertiesPanel
            app.PropertiesPanel = uipanel(app.UIFigure);
            app.PropertiesPanel.Title = 'Properties';
            app.PropertiesPanel.Position = [32 73 258 177];

            % Create SamplingfrequencySpinnerLabel
            app.SamplingfrequencySpinnerLabel = uilabel(app.PropertiesPanel);
            app.SamplingfrequencySpinnerLabel.HorizontalAlignment = 'right';
            app.SamplingfrequencySpinnerLabel.Position = [21 77 115 22];
            app.SamplingfrequencySpinnerLabel.Text = 'Sampling frequency:';

            % Create SamplingfrequencySpinner
            app.SamplingfrequencySpinner = uispinner(app.PropertiesPanel);
            app.SamplingfrequencySpinner.Step = 0.1;
            app.SamplingfrequencySpinner.Limits = [0 Inf];
            app.SamplingfrequencySpinner.Position = [151 77 71 22];
            app.SamplingfrequencySpinner.Value = 0.1;

            % Create FrequencyresolutionSpinnerLabel
            app.FrequencyresolutionSpinnerLabel = uilabel(app.PropertiesPanel);
            app.FrequencyresolutionSpinnerLabel.HorizontalAlignment = 'right';
            app.FrequencyresolutionSpinnerLabel.Position = [15 119 121 22];
            app.FrequencyresolutionSpinnerLabel.Text = 'Frequency resolution:';

            % Create FrequencyresolutionSpinner
            app.FrequencyresolutionSpinner = uispinner(app.PropertiesPanel);
            app.FrequencyresolutionSpinner.Step = 0.1;
            app.FrequencyresolutionSpinner.Position = [151 119 71 22];
            app.FrequencyresolutionSpinner.Value = 0.1;

            % Create MaxfrequencySpinnerLabel
            app.MaxfrequencySpinnerLabel = uilabel(app.PropertiesPanel);
            app.MaxfrequencySpinnerLabel.HorizontalAlignment = 'right';
            app.MaxfrequencySpinnerLabel.Position = [48 30 88 22];
            app.MaxfrequencySpinnerLabel.Text = 'Max frequency:';

            % Create MaxfrequencySpinner
            app.MaxfrequencySpinner = uispinner(app.PropertiesPanel);
            app.MaxfrequencySpinner.Step = 0.1;
            app.MaxfrequencySpinner.Limits = [0 Inf];
            app.MaxfrequencySpinner.Position = [151 30 71 22];
            app.MaxfrequencySpinner.Value = 0.1;

            % Create CancelButton
            app.CancelButton = uibutton(app.UIFigure, 'push');
            app.CancelButton.ButtonPushedFcn = createCallbackFcn(app, @CancelButtonPushed, true);
            app.CancelButton.Position = [211 32 79 22];
            app.CancelButton.Text = 'Cancel';

            % Create OkButton
            app.OkButton = uibutton(app.UIFigure, 'push');
            app.OkButton.ButtonPushedFcn = createCallbackFcn(app, @OkButtonPushed, true);
            app.OkButton.Position = [116 32 85 22];
            app.OkButton.Text = 'Ok';
        end
    end

    methods (Access = public)

        % Construct app
        function app = freqresol_maxfreq_samplfreq_guide

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end