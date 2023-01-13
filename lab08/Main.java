import com.espertech.esper.common.client.configuration.Configuration;
import com.espertech.esper.runtime.client.EPRuntime;
import com.espertech.esper.runtime.client.EPRuntimeProvider;
import com.espertech.esper.common.client.EPCompiled;
import com.espertech.esper.common.client.configuration.Configuration;
import com.espertech.esper.compiler.client.CompilerArguments;
import com.espertech.esper.compiler.client.EPCompileException;
import com.espertech.esper.compiler.client.EPCompilerProvider;
import com.espertech.esper.runtime.client.*;

import java.io.IOException;

public class Main {
    public static EPDeployment compileAndDeploy(EPRuntime epRuntime, String epl) {
        EPDeploymentService deploymentService = epRuntime.getDeploymentService();
        CompilerArguments args = new CompilerArguments(epRuntime.getConfigurationDeepCopy());
        EPDeployment deployment;
        try {
            EPCompiled epCompiled = EPCompilerProvider.getCompiler().compile(epl, args);
            deployment = deploymentService.deploy(epCompiled);
        } catch (EPCompileException e) {
            throw new RuntimeException(e);
        } catch (EPDeployException e) {
            throw new RuntimeException(e);
        }
        return deployment;
    }

    public static void main(String[] args) throws IOException {
        Configuration configuration = new Configuration();
        configuration.getCommon().addEventType(KursAkcji.class);
        EPRuntime epRuntime = EPRuntimeProvider.getDefaultRuntime(configuration);

        EPDeployment deployment = compileAndDeploy(epRuntime,
                "select irstream spolka as X, kursOtwarcia as Y " +
                        "from KursAkcji.win:length(3) ");


        ProstyListener prostyListener = new ProstyListener();
        for (EPStatement statement : deployment.getStatements()) {
            statement.addListener(prostyListener);
        }

        InputStream inputStream = new InputStream();
        inputStream.generuj(epRuntime.getEventService());
    }
}

/*
Zad 24
    "select irstream spolka as X, kursOtwarcia as Y " +
    "from KursAkcji.win:length(3) " +
    "where spolka = 'Oracle' "

Zad 25
     "select irstream data, kursOtwarcia, spolka " +
     "from KursAkcji.win:length(3) " +
     "where spolka = 'Oracle' "

Zad 26
     "select irstream data, kursOtwarcia, spolka " +
     "from KursAkcji(spolka='Oracle').win:length(3) "

Zad 27
     "select istream data, kursOtwarcia, spolka " +
     "from KursAkcji(spolka='Oracle').win:length(3) "

Zad 28
     "select istream data, max(kursOtwarcia), spolka " +
     "from KursAkcji(spolka='Oracle').win:length(5) "

Zad 29
     "select istream data, kursOtwarcia - max(kursOtwarcia) as roznica, spolka " +
     "from KursAkcji(spolka='Oracle').win:length(5) "

Zad 30
     "select istream data, kursOtwarcia - min(kursOtwarcia) as roznica, spolka " +
     "from KursAkcji(spolka='Oracle').win:length(2) " +
     "having kursOtwarcia > MIN(kursOtwarcia) "
 */