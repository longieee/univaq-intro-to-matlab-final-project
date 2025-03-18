function results = runMATLABTests()
    import matlab.unittest.TestSuite
    import matlab.unittest.TestRunner
    import matlab.unittest.plugins.CodeCoveragePlugin
    import matlab.unittest.plugins.codecoverage.CoberturaFormat

    % Add utils folder to path
    addpath('utils');

    % Create a test suite
    suite = TestSuite.fromFolder('tests');

    % Create a test runner
    runner = TestRunner.withTextOutput;

    % Add Code Coverage Plugin
    coverageFile = 'coverage.xml';
    plugin = CodeCoveragePlugin.forFolder('utils', 'IncludingSubfolders', true, ...
        'Format', CoberturaFormat(coverageFile));
    runner.addPlugin(plugin);

    % Run the tests
    results = runner.run(suite);
    disp(results);
end
