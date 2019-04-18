classdef hhgm_params_guide < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        HHHGMParametersUIFigure    matlab.ui.Figure
        ParametersPanel            matlab.ui.container.Panel
        maxiter_innerSpinnerLabel  matlab.ui.control.Label
        maxiter_innerSpinner       matlab.ui.control.Spinner
        maxiter_outerSpinnerLabel  matlab.ui.control.Label
        maxiter_outerSpinner       matlab.ui.control.Spinner
        penaltySpinnerLabel        matlab.ui.control.Label
        penaltySpinner             matlab.ui.control.Spinner
        rthSpinnerLabel            matlab.ui.control.Label
        rthSpinner                 matlab.ui.control.Spinner
        axiEditFieldLabel          matlab.ui.control.Label
        axiEditField               matlab.ui.control.EditField
        sigma2xiEditFieldLabel     matlab.ui.control.Label
        sigma2xiEditField          matlab.ui.control.EditField
        ssbl_thSpinnerLabel        matlab.ui.control.Label
        ssbl_thSpinner             matlab.ui.control.Spinner
        CancelButton               matlab.ui.control.Button
        OkButton                   matlab.ui.control.Button
    end

    
    properties (Access = private)
        Property % Description
    end
    
    properties (Access = public)
        canceled
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
            app.canceled = true;
            uiresume(app.HHHGMParametersUIFigure);
            close();
        end

        % Button pushed function: OkButton
        function OkButtonPushed(app, event)
            properties_file = strcat('properties',filesep,'properties.xml');
            root_tab =  'properties';
           
            maxiter_outer = app.maxiter_outerSpinner.Value;
            maxiter_inner =  app.maxiter_innerSpinner.Value;
            penalty = app.penaltySpinner.Value;
            rth = app.rthSpinner.Value;
            
            parameters = ["param.maxiter_outer","param.maxiter_inner","param.penalty",...
                "param.rth","param.axi","param.sigma2xi","param.ssbl_th"];
            values = [maxiter_outer,maxiter_inner,penalty,rth];
            
                        
            axi = app.axiEditField.Value;
            expression = '[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?';
            splitStr = regexp(axi,expression);
            if (isempty(splitStr)  | splitStr ~=1)
                msgbox('The axi field has a wrong format','Info');
                app.axiEditField.Value = '1e-3';
                return;
            end
            values = [values, str2double(axi)];
            
            sigma2xi = app.sigma2xiEditField.Value;
            expression = '[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?';
            splitStr = regexp(sigma2xi,expression);
             if (isempty(splitStr)  | splitStr ~=1)
                msgbox('The sigma2xi field has a wrong format','Info');
                app.sigma2xiEditField.Value = '1e0';
                return;
            end
            values = [values, str2double(sigma2xi)];
            
            ssbl_th = app.ssbl_thSpinner.Value;
            values = [values, ssbl_th];
            
            change_xml_parameter(properties_file,root_tab,parameters,values); 
            
            app.canceled = false;            
            uiresume(app.HHHGMParametersUIFigure);  
            close();
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create HHHGMParametersUIFigure
            app.HHHGMParametersUIFigure = uifigure;
            app.HHHGMParametersUIFigure.Position = [100 100 447 295];
            app.HHHGMParametersUIFigure.Name = 'H-HHGM Parameters';

            % Create ParametersPanel
            app.ParametersPanel = uipanel(app.HHHGMParametersUIFigure);
            app.ParametersPanel.Title = 'Parameters';
            app.ParametersPanel.Position = [32 60 384 201];

            % Create maxiter_innerSpinnerLabel
            app.maxiter_innerSpinnerLabel = uilabel(app.ParametersPanel);
            app.maxiter_innerSpinnerLabel.HorizontalAlignment = 'right';
            app.maxiter_innerSpinnerLabel.Position = [12 101 78 22];
            app.maxiter_innerSpinnerLabel.Text = 'maxiter_inner';

            % Create maxiter_innerSpinner
            app.maxiter_innerSpinner = uispinner(app.ParametersPanel);
            app.maxiter_innerSpinner.Limits = [0 Inf];
            app.maxiter_innerSpinner.Tooltip = {'maximum number of iterations of the h-hggm outer cycle'};
            app.maxiter_innerSpinner.Position = [105 101 71 22];
            app.maxiter_innerSpinner.Value = 100;

            % Create maxiter_outerSpinnerLabel
            app.maxiter_outerSpinnerLabel = uilabel(app.ParametersPanel);
            app.maxiter_outerSpinnerLabel.HorizontalAlignment = 'right';
            app.maxiter_outerSpinnerLabel.Position = [11 143 79 22];
            app.maxiter_outerSpinnerLabel.Text = 'maxiter_outer';

            % Create maxiter_outerSpinner
            app.maxiter_outerSpinner = uispinner(app.ParametersPanel);
            app.maxiter_outerSpinner.Limits = [1 Inf];
            app.maxiter_outerSpinner.Tooltip = {'maximum number of iterations for h-hggm inner cycle: iterations of the hggm-lasso'};
            app.maxiter_outerSpinner.Position = [105 143 71 22];
            app.maxiter_outerSpinner.Value = 60;

            % Create penaltySpinnerLabel
            app.penaltySpinnerLabel = uilabel(app.ParametersPanel);
            app.penaltySpinnerLabel.HorizontalAlignment = 'right';
            app.penaltySpinnerLabel.Position = [46 59 44 22];
            app.penaltySpinnerLabel.Text = 'penalty';

            % Create penaltySpinner
            app.penaltySpinner = uispinner(app.ParametersPanel);
            app.penaltySpinner.Step = 0.1;
            app.penaltySpinner.Limits = [0.1 Inf];
            app.penaltySpinner.Tooltip = {'penalization function of the source partial correlations in h-hggm: 0 (naive) 1 (lasso) 2 (ridge)'};
            app.penaltySpinner.Position = [105 59 71 22];
            app.penaltySpinner.Value = 1;

            % Create rthSpinnerLabel
            app.rthSpinnerLabel = uilabel(app.ParametersPanel);
            app.rthSpinnerLabel.HorizontalAlignment = 'right';
            app.rthSpinnerLabel.Position = [65 16 25 22];
            app.rthSpinnerLabel.Text = 'rth';

            % Create rthSpinner
            app.rthSpinner = uispinner(app.ParametersPanel);
            app.rthSpinner.Step = 0.1;
            app.rthSpinner.Limits = [0.1 Inf];
            app.rthSpinner.Tooltip = {'rayleigh threshold: 3.16 (90 percentile of the partial correlation in the subspace of the null hypothesis)'};
            app.rthSpinner.Position = [105 16 71 22];
            app.rthSpinner.Value = 3.16;

            % Create axiEditFieldLabel
            app.axiEditFieldLabel = uilabel(app.ParametersPanel);
            app.axiEditFieldLabel.HorizontalAlignment = 'right';
            app.axiEditFieldLabel.Position = [240 141 25 22];
            app.axiEditFieldLabel.Text = 'axi';

            % Create axiEditField
            app.axiEditField = uieditfield(app.ParametersPanel, 'text');
            app.axiEditField.HorizontalAlignment = 'right';
            app.axiEditField.Tooltip = {'noise inferior threshold (it can be determined experimentally from the recording''s system background signal)'};
            app.axiEditField.Position = [280 141 74 22];
            app.axiEditField.Value = '1e-3';

            % Create sigma2xiEditFieldLabel
            app.sigma2xiEditFieldLabel = uilabel(app.ParametersPanel);
            app.sigma2xiEditFieldLabel.HorizontalAlignment = 'right';
            app.sigma2xiEditFieldLabel.Position = [213 99 53 22];
            app.sigma2xiEditFieldLabel.Text = 'sigma2xi';

            % Create sigma2xiEditField
            app.sigma2xiEditField = uieditfield(app.ParametersPanel, 'text');
            app.sigma2xiEditField.HorizontalAlignment = 'right';
            app.sigma2xiEditField.Tooltip = {'initial value of noise variance'};
            app.sigma2xiEditField.Position = [281 99 73 22];
            app.sigma2xiEditField.Value = '1e0';

            % Create ssbl_thSpinnerLabel
            app.ssbl_thSpinnerLabel = uilabel(app.ParametersPanel);
            app.ssbl_thSpinnerLabel.HorizontalAlignment = 'right';
            app.ssbl_thSpinnerLabel.Position = [224 59 44 22];
            app.ssbl_thSpinnerLabel.Text = 'ssbl_th';

            % Create ssbl_thSpinner
            app.ssbl_thSpinner = uispinner(app.ParametersPanel);
            app.ssbl_thSpinner.Step = 0.1;
            app.ssbl_thSpinner.Limits = [0.1 Inf];
            app.ssbl_thSpinner.Tooltip = {'rayleigh threshold: 3.16 (90 percentile of the partial correlation in the subspace of the null hypothesis)'};
            app.ssbl_thSpinner.Position = [283 59 71 22];
            app.ssbl_thSpinner.Value = 1;

            % Create CancelButton
            app.CancelButton = uibutton(app.HHHGMParametersUIFigure, 'push');
            app.CancelButton.ButtonPushedFcn = createCallbackFcn(app, @CancelButtonPushed, true);
            app.CancelButton.Position = [338 18 79 22];
            app.CancelButton.Text = 'Cancel';

            % Create OkButton
            app.OkButton = uibutton(app.HHHGMParametersUIFigure, 'push');
            app.OkButton.ButtonPushedFcn = createCallbackFcn(app, @OkButtonPushed, true);
            app.OkButton.Position = [243 18 85 22];
            app.OkButton.Text = 'Ok';
        end
    end

    methods (Access = public)

        % Construct app
        function app = hhgm_params_guide

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.HHHGMParametersUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.HHHGMParametersUIFigure)
        end
    end
end