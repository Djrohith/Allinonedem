import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()
def strategy = new hudson.security.GlobalMatrixAuthorizationStrategy()
strategy.add(Jenkins.ADMINISTER, 'admin')
instance.setAuthorizationStrategy(strategy)
instance.save()
