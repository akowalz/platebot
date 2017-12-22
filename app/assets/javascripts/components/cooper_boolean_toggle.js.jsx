class CooperBooleanToggle extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      cooper: this.props.cooper,
      showUpdateNotice: false,
      isLoading: false,
    }

    this.handleYesClick = this.handleYesClick.bind(this);
    this.handleNoClick = this.handleNoClick.bind(this);
    this.setBooleanValue = this.setBooleanValue.bind(this);
  }

  render() {
    let attributeValue = this.state.cooper[this.props.booleanAttributeName];

    return (
      <div id={this.props.cooper.id}>
        <div className="btn-group" role="group">
          <button onClick={this.handleYesClick} className={"btn btn-md btn-" + (attributeValue ? "success" : "default")}>
            Yes
          </button>
          <button onClick={this.handleNoClick} className={"btn btn-md btn-" + (attributeValue ? "default" : "danger")}>
            No
          </button>
        </div>
        <span className={`toggle-update-notice ${this.state.showUpdateNotice ? 'showing' : 'hiding'}`}>
          {this.state.isLoading ?  "loading.." : "Updated!"}
        </span>
      </div>
    );
  }

  handleYesClick() {
    this.setBooleanValue(true);
  }

  handleNoClick() {
    this.setBooleanValue(false);
  }

  setBooleanValue(val) {
    var body = {"cooper": {}}
    body.cooper[this.props.booleanAttributeName] = val

    this.setState({isLoading: true, showUpdateNotice: true}, () => {
      fetch("/api/coopers/" + this.props.cooper.id, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(body)
      }).then((response) => {
        return response.json();
      }).then((json) => {
        this.setState({
          cooper: json.cooper,
          isLoading: false
        }, () => {
          setTimeout(() => {
            this.setState({showUpdateNotice: false});
          }, 1000);
        });
      });
    });
  }
}
